.. sectionauthor:: Kadir Akbudak <kadir.akbudak@kaust.edu.sa>
.. meta::
    :description: gdb4hpc
    :keywords: debugging,gdb4hpc


*******
gdb4hpc
*******

gdb4hpc is used to debug parallel applications with multiple MPI ranks.

The debugger can be run as follows:

.. code-block:: bash

    $ salloc -N 2
    $ module load cray-cti gdb4hpc
    $ module unload xalt
    $ gdb4hpc
    gdb4hpc 4.13.5 - Cray Line Mode Parallel Debugger
    ...

    dbg all> launch $a{8} --launcher-args="-N2" ./my_binary
    Starting application, please wait...
    Created network...
    Creating MRNet communication network...
    Waiting for debug servers to attach to MRNet communications network...
    Timeout in 400 seconds. Please wait for the attach to complete.
    Number of dbgsrvs connected: [0];  Timeout Counter: [1]
    Finalizing setup...
    Launch complete.
    a{0..7}: Initial breakpoint, main at /lustre/scratch/my_code.c:10

    dbg all> bt
    a{0..7}: #0  main at /lustre/scratch/my_code:10

.. toctree::
   :titlesonly:
   :maxdepth: 1
   :hidden:


