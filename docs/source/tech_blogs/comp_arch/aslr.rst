Performance variability related to ASLR (Address Space Layout Randomization) mode
=================================================================================

We have observed performance variability on some MPI applications due to ASLR
(Address Space Layout Randomization) mode. This short notice explains what
ASLR mode is, and how it leads to performance variability. It explains also
how to deactivate ASLR to remove this source of performance variability.

ASLR for Address Space Layout Randomization is a feature that randomly
changes virtual memory addresses of process memory segment, including stack
position, heap position and the position of memory segment of each shared
memory libraries (``*.so`` files) used by a process. This feature increases
security of process against cyber-attack by buffer overflow. In an MPI
application the randomization is per MPI rank, because each rank uses a
different UNIX process.

What is ASLR mode?
------------------

The ASLR mode is set at system level, current configuration can be view with
following commands:

.. code-block::

  > sysctl kernel.randomize_va_space
  kernel.randomize_va_space = 1

ASLR mode is ON if the system parameter value is not zero.

ASLR mode can be deactivated at user level for a specific launch by prefixing
application launch with following UNIX command:

.. code-block::

  > setarch x86_64 -R <application> ...

The effect of ASLR mode can be observed with repeated ``ldd`` command on a
binary (command output is not shown here).

.. code-block::

  > ldd <application>
  > ldd <application>
  > setarch x86_64 -R ldd <application>
  > setarch x86_64 -R ldd <application>

If ASLR mode is ON virtual memory addresses of shared libraries reported by
``ldd`` change from one call to another, while switching ASLR mode OFF fix
memory addressed reported by ``ldd`` for each call.

It is also possible to observe the effect of ASLR mode with a repeated call to
maps view (command output is not shown here).

.. code-block::

  > cat /proc/self/maps
  > cat /proc/self/maps
  > setarch x86_64 -R cat /proc/self/maps
  > setarch x86_64 -R cat /proc/self/maps

These commands show all the memory segments of the ``cat`` command. With ASLR
mode ON we can observe that virtual memory address of each segment changes from
one run to another. While with ASLR mode OFF, virtual addresses of each memory
segment are fixed.

Effect of ASLR on performance.
------------------------------

We have observed in application a variability of performance from one run to
another, and with a small probability of around one process over 10000, the
performances are up to 30% slower than the average. This probability is small
but for a run on 128 nodes with 24576 ranks, the probability of having a slow
rank is 2%. The effect on MPI applications is an artificial increase of load
imbalance due to the slow rank, and performance variability from one run to
another. The profiling of the application shows also that performance
degradation happens inside a loop with repeated call to power function, a
function implemented into shared library libm.so. We have replaced call to
power function to other intrinsic functions implemented in shared library
``libm.so``, and observed the same effect.

How to avoid performance variability?
-------------------------------------

We have shown on real application that switching ASLR mode off for all ranks
is enough to solve the issue. The unix command ``setarch x86_64 -R <application>``
allow a user to switch ASLR mode off for any sub-UNIX process. So for an MPI
application, it is just necessary to insert the command between the launcher
command and the application.

.. code-block::

  srun … setarch x86_64 -R <application> …

Conclusion
----------

At this stage we think that ASLR mode is braking page coloring mechanism that
optimizes virtual memory mapping to physical pages to optimize cache memory usage
for data and code.

Sample test to reproduce the issue.
-----------------------------------

I add in attachment the archive TEST_VAR_ASLR.tgz that contains a simplified
(C + MPI) test to reproduce the variability effect of ASLR mode. It can be run
on one node and generates enough measure in around an hour to compare ASLR mode
ON and OFF.

This test is inspired by the issue observed in a real application. It
repeatedly calls power function (pow) function in shared libm. The test measure
consecutive bunch of repeated calls on each MPI rank. It then prints statistics
per rank.

The test should show low performance variability over time per MPI ranks, but
should show high performance variability between MPI ranks and between runs,
if ASLR mode is ON, and low performance variability between MPI ranks if ASLR
mode is OFF.

The occurrence of very slow runs is low, this is 1 rank over 10000.

In real application performance variability per rank generates load imbalance
that is responsible for performance variability on high number of ranks.

Launch test
^^^^^^^^^^^^

slurm script use 2 node and 384 ranks, and launch a sequence of 200 tests,
alternatively forcing ASLR mode ON and OFF. Launch with ASLR mode ON and OFF
are interlaced to show that there is no effect related to system aging.

The slurm command has a fixed frequency (``--cpu-freq=highm``) to remove turbo
mode. And enforces a biding of MPI ranks (``--cpu-bind=map_cpu:...``).

Remember that the occurrence of the issue is only 1 over 10000 ranks.
Ensure making enough repetition, to get one slow run with ASLR ON.

It is possible to launch the script simultaneously on different nodes to get
more samples and help to discard network or IO incidents.

Analyzing results
^^^^^^^^^^^^^^^^^

The test generates one output file per instance with statistics on real time
of each step per rank.

Files with ASLR mode ON are in files:
``run-<JOBID>/logfile_ASLR-ON_<JOBID>_<RUN-IDX>.out``

Files with ASLR mode OFF (prefixed with ``setarch x86_64 -R``) are in files:
``run-<JOBID>/logfile_ASLR-OFF_<JOBID>_<RUN-IDX>.out``

Output files look like:

.. code-block::

  nbStep=100 nbRepeat=20, nbValue=100000
  Compute time (s) per rank over 100 time steps.
     Rank Min      Max      Avg      StdDev   : StdDev/Avg (Max-Min)/Avg
  CT: 000 0.122869 0.124279 0.123006 0.000182 : 0.148 %  1.146 %
  CT: 158 0.122678 0.124037 0.122765 0.000149 : 0.121 %  1.107 %
  CT: 191 0.122649 0.123257 0.122736 0.000097 : 0.079 %  0.495 %
  [...]

Each line prefixed with CT: contains statistics of an MPI rank.

It is then possible to aggregate those statistics between multiple runs
with ministat tools.

Here are the statistics on average time step (column 5) of each rank of
each run of the same job 1454489 with ASLR OFF done with ministat.

.. code-block::

  > grep CT run-1454489/logfile_ASLR-OFF*.out | ./ministat-linux/ministat -C 5 | tail
  |   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xx x               |
  |   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xx xx              |
  |  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxx    x         |
  |  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   xx        |
  |  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx x xx        |
  |xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   xx  x|
  |              |______A_______|                                            |
  +--------------------------------------------------------------------------+
      N           Min           Max        Median           Avg        Stddev
  x 38016      0.122599      0.123058      0.122731    0.12273217 4.6233999e-05


To compare with statistics on average time step (column 5) of each rank of
each run of the same job with ASLR ON

.. code-block::

  > grep CT run-1454489/logfile_ASLR-ON*.out | ./ministat-linux/ministat -C 5 | tail
  |   x xxxx                                                                 |
  |x xx xxxx                                                                 |
  |x xxxxxxx                                                                 |
  |x xxxxxxx x                                                               |
  |x xxxxxxx x                                                               |
  |xxxxxxxxxxxxx      x                                  x                  x|
  |      |A                                                                  |
  +--------------------------------------------------------------------------+
      N           Min           Max        Median           Avg        Stddev
  x 38016      0.102765      0.314722      0.122733    0.12266993  0.0014776222

The standard deviation is higher with ASLR ON than with ASLR OFF. And 3 ranks
over 38016 are slower than others. One measure takes close to 3 times more time.

For deeper analysis it is possible to extract slowest execution of each mode.
With ASLR OFF the 4 slowest ranks over all runs of job 1454489.

.. code-block::

  > grep CT run-1454489/logfile_ASLR-OFF*.out | sort -n -k 5 | tail -n 4
                                                  Rank Min      Max      Avg     StdDev   : StdDev/Avg (Max-Min)/Avg
  run-1454489/logfile_ASLR-OFF_1454489_21.out:CT: 366 0.122785 0.125385 0.123009 0.000486 : 0.395 %  2.113 %
  run-1454489/logfile_ASLR-OFF_1454489_01.out:CT: 000 0.122906 0.123853 0.123033 0.000154 : 0.125 %  0.770 %
  run-1454489/logfile_ASLR-OFF_1454489_14.out:CT: 000 0.122911 0.123674 0.123037 0.000143 : 0.116 %  0.620 %
  run-1454489/logfile_ASLR-OFF_1454489_42.out:CT: 000 0.122907 0.124921 0.123058 0.000240 : 0.195 %  1.636 %

To compare with ASLR ON the 4 slowest ranks over all runs of job 1454489.

.. code-block::

  grep CT run-1454489/logfile_ASLR-ON*.out | sort -n -k 5 | tail -n 4
                                                 Rank Min      Max      Avg     StdDev   : StdDev/Avg (Max-Min)/Avg
  run-1454489/logfile_ASLR-ON_1454489_91.out:CT: 141 0.137082 0.137909 0.137285 0.000126 : 0.092 %  0.603 %
  run-1454489/logfile_ASLR-ON_1454489_58.out:CT: 355 0.158356 0.159244 0.158550 0.000121 : 0.077 %  0.560 %
  run-1454489/logfile_ASLR-ON_1454489_07.out:CT: 110 0.260405 0.261725 0.260570 0.000193 : 0.074 %  0.507 %
  run-1454489/logfile_ASLR-ON_1454489_05.out:CT: 244 0.310796 0.316510 0.314722 0.000903 : 0.287 %  1.816 %

The last 4 lines with ASLR mode ON are slower than average of other runs with
ASLR mode OFF. And measure is stable for all steps (small relative standard
deviation, last 2 columns). This is root cause of performance variability we
are tracking.

It is also possible to extract measurement on each rank of this run 05.
So only one MPI rank (rank 244) of this run is affected by a slow execution.

.. code-block::

  > grep CT run-1454489/logfile_ASLR-ON_1454489_05.out | ./ministat-linux/ministat -C 5 | tail
  |   x                                                                      |
  |   x                                                                      |
  |   x                                                                      |
  |   x                                                                      |
  |   x                                                                      |
  |  xx                                                                     x|
  ||__MA__|                                                                  |
  +--------------------------------------------------------------------------+
      N           Min           Max        Median           Avg        Stddev
  x 384      0.120286      0.314722      0.122727    0.12320954  0.0098000852

These measures have been done using 2 nodes. It is possible to see the same
effect using only one node, but it may be harder to track slow cases.


