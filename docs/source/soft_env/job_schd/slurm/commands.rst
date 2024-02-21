.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: SLURM commands
    :keywords: SLURM,job scheduling

.. _slurm_commands:

================
Common commands
================

Slurm offers various commands and utilites for interacting with a cluster.
The following sections list fundamental commands every user of KSL computational platforms should be familiar with. 

Slurm utilities
===============
SLURM provides utilites for:

#. querying resources and their status
#. specifying and submiting resource requests
#. monitoring and managing the submitted resources
#. reporting for usage

Querying system resource
-------------------------

.. _slurm_queues:

sinfo
******

``sinfo`` command gives an overview of the resources offered by the cluster, while the squeue command shows to which jobs those resources are currently allocated.
By default, sinfo lists the partitions that are available. A partition is a set of compute nodes (computers dedicated to ... computing,) grouped logically. Typical examples include partitions dedicated to batch processing, debugging, post processing, or visualization.

.. code-block:: bash
    :caption: an example output of ``sinfo`` on Shaheen III

    xyz123@cdl4> sinfo

    PARTITION   AVAIL JOB_SIZE  TIMELIMIT   CPUS  S:C:T NODES STATE     
    workq*      up    1-6158   1-00:00:00     64 2:16:2     3 down*     
    workq*      up    1-6158   1-00:00:00     64 2:16:2     4 drained   
    workq*      up    1-6158   1-00:00:00     64 2:16:2  2289 allocated 
    workq*      up    1-6158   1-00:00:00     64 2:16:2  3862 idle      
    72hours     up    1-512    3-00:00:00     64 2:16:2     3 down*     
    72hours     up    1-512    3-00:00:00     64 2:16:2     4 drained   
    72hours     up    1-512    3-00:00:00     64 2:16:2  2289 allocated 
    72hours     up    1-512    3-00:00:00     64 2:16:2  3858 idle      
    debug       up    1-4           30:00     64 2:16:2    16 idle  

The output of ``sinfo`` is a snapshot of the total resources, those in use, and avialable in different partitions in SLURM on the target KSL platform.
This command accepts a number of filters to modify the default output based on the information needed. 
For more information please try ``man sinfo`` for a detailed guide for using ``sinfo``.

.. _slurm_squeue:

squeue
*******

``squeue`` is a convinient SLURM command to query status of jobs on the target KSL platforms. 
The default output of this command is a list of all the jobs submitted by users, their state, and either forecasted start time or elapsed time for pending and running jobs respectively.

.. code-block:: bash
    :caption: an example output of ``squeue`` on Shaheen III
    
    cdl4:~> squeue
    JOBID       USER     ACCOUNT           NAME  ST REASON    START_TIME                TIME  TIME_LEFT NODES
    32794944    #######   k####         PAR_BN   R  None      2023-07-31T14:45:31   23:57:52       2:08     1
    32803782    #######   k####       A_120714   R  None      2023-08-01T14:37:01       6:22       3:38     1
    32794946    #######   k####       PAR_ring   R  None      2023-07-31T14:48:02   23:55:21       4:39     1
    32754321    #######   k####      threenode  PD AssocMaxJ  N/A                       0:00 3-00:00:00     3
    32798918    #######   k####      AGRA12_13  PD Dependenc  N/A                       0:00 1-00:00:00     1
    32803362    #######   k####         run_63  PD Dependenc  N/A                       0:00   23:59:00    52

It is common to limit the default output to a user's own jobs. For this, ``squeue`` conviniently provide filter by:

* username
* jobname
* jobid

For example

.. code-block:: bash
    :caption: filtering the ``squeue`` output by username

    cdl2:~> squeue -u $USER
    JOBID       USER    ACCOUNT           NAME  ST REASON    START_TIME                TIME  TIME_LEFT NODES
    32803928    xyz        k01   jupyter-dask   R None      2023-08-01T14:57:02       1:13      58:47     1
    32803927    xyz        k01     task.slurm   R None      2023-08-01T14:56:20       1:55    1:58:05     5


.. code-block:: bash
    :caption: filtering the ``squeue`` output by jobname
    
    cdl2:~> squeue -n jupyter-dask
    JOBID       USER     ACCOUNT          NAME  ST REASON    START_TIME                TIME  TIME_LEFT NODES
    32803928     xyz        k01   jupyter-dask   R None      2023-08-01T14:57:02       1:13      58:47     1

.. code-block:: bash
    :caption: filtering the ``squeue`` output by jobid
    
    cdl2:~> squeue -j 32803928
    JOBID       USER      ACCOUNT         NAME  ST REASON    START_TIME                TIME  TIME_LEFT NODES
    32803927     xyz        k01     task.slurm   R None      2023-08-01T14:56:20       1:55    1:58:05     5



Specifying resources
--------------------

Allocation requests can constitute of three computational resources and the duration for which they are needed by your job.

* CPUs/GPUs
* Memory
* Local storage 
* Wall time

You can either run your work as a `batch job` or an `interactive job`.
For a batch job:

* You will need a job script with resource request and the commands to run on that resource once allocated.
* SLURM will run the script on your behalf once the requested resources are available.
* Resources can be requested for longer durations (several hours)

For an interactive job:

* Resource requests are usually small and short
* You run each command by typing it interactively
* Useful for prototyping and debugging


sbatch 
*********

``sbatch`` command submits your jobscript to SLURM.  

* Upon successful submission a unique job ID is assigned
* Job is queued and awaits allocation of the requested resources
* a priority is assigned to each job based on first come basis
* In general, shorter and smaller jobs are easier to scheduler
* After the successful submission, the status of a queued job is Pending (PD) until resources are available

.. code-block:: bash
    :caption: submitting a batch job to SLURM
    
    > sbatch my-jobscript.slurm
    Submitted batch job 33204519

.. _slurm_salloc: 

salloc
*******
Users can allocate compute resources for a limited time to use interactively. This means the commands typed on the prompt will run instantly and control is given back at the end of the process. Most common usecase of requesting such allocations is debugging or testing commands to ultimately create scripts.

``salloc`` command to request allocation of resource for interactive use.

.. code-block:: bash
    :caption:  A simple example  for using ``salloc``


    xyz@cld2> salloc --partition=debug –N 2 
    salloc: Granted job allocation 12130189

    xyz@gateway2:> srun -n 64 --hint=nomultithread ./helloworld 

    Hello from rank  0 of 64
    Hello from rank  1 of 64
    ….
    Hello from rank 63 of 64

    xyz@gateway2:> exit
    xyz@cdl2:>

.. _slurm_srun: 

srun
*****

Once compute resources are allocated, ``srun`` command can be used to launch your application on to the compute resources

.. code-block:: bash
    :caption: using ``srun``
    
    user123@cdl2:~> salloc --partition=debug -N 2
    salloc: Granted job allocation 12140840
    
    export OMP_NUM_THREADS=4
    srun --hint=nomultithread --ntasks=16 --cpus-per-task=4 ./hello_world

* Each srun command is considered as "job step" for the corresponding allocation by SLURM.
* When a job step completes, the allocation does not automatically terminate.
* This means you can run multiple job steps with different configurations.

Monitoring and managing jobs
-----------------------------

SLURM has utilities to monitor the status of jobs and manage them accordingly.  

scancel
*******
Users can cancel a submitted job in any state, using the SLURM command ``scancel``.
``scancel`` requires job ID as its argument. An example below shows the use of ``scancel``

.. code-block:: 
    :caption: using ``scancel``

    xyz@cdl4> squeue -u $USER
        JOBID       USER ACCOUNT           NAME  ST REASON    START_TIME     TIME  TIME_LEFT NODES
    33204827        xyz     k01     test.slurm  PD Priority  N/A             0:00    1:00:00     1

    xyz@cdl4> scancel  33204827

    xyz@cdl4> squeue -u $USER
        JOBID       USER ACCOUNT           NAME  ST REASON    START_TIME     TIME  TIME_LEFT NODES


scontrol
********

``scontrol`` command is one of the more powerful commands of SLURM. Amongst other things, it allows a user to show parameters of requested and allocated resource for a job in queue (in any state i.e running, pending, etc).

.. code-block:: bash
    :caption: a sample output of ``scontrol`` command

    > scontrol show job 33204891
    JobId=33204891 JobName=test.slurm
    UserId=xyz123(123456) GroupId=g-xyz123(123456) MCS_label=N/A
    Priority=1 Nice=0 Account=k01 QOS=normal
    JobState=PENDING Reason=Priority Dependency=(null)
    Requeue=1 Restarts=0 BatchFlag=1 Reboot=0 ExitCode=0:0
    RunTime=00:00:00 TimeLimit=01:00:00 TimeMin=N/A
    SubmitTime=2023-09-28T16:50:51 EligibleTime=2023-09-28T16:50:51
    AccrueTime=2023-09-28T16:50:51
    StartTime=Unknown EndTime=Unknown Deadline=N/A
    SuspendTime=None SecsPreSuspend=0 LastSchedEval=2023-09-28T16:50:51 Scheduler=Main
    Partition=workq AllocNode:Sid=cdl4:37447
    ReqNodeList=(null) ExcNodeList=(null)
    NodeList=(null)
    NumNodes=1 NumCPUs=1 NumTasks=1 CPUs/Task=1 ReqB:S:C:T=0:0:*:*
    TRES=cpu=1,mem=128803M,node=1,billing=1
    Socks/Node=* NtasksPerN:B:S:C=0:0:*:* CoreSpec=*
    MinCPUsNode=1 MinMemoryNode=0 MinTmpDiskNode=0
    eatures=(null) DelayBoot=00:00:00
    OverSubscribe=NO Contiguous=0 Licenses=(null) Network=(null)
    Command=/lustre/scratch/xyz123/delft3d/Run01_M/test.slurm
    WorkDir=/lustre/scratch/xyz123/delft3d/Run01_M
    StdErr=/lustre/scratch/xyz123/tickets/delft3d/Run01_M/slurm-33204891.out
    StdIn=/dev/null
    StdOut=/lustre/scratch/xyz123/delft3d/Run01_M/slurm-33204891.out
    Power=


squeue
*******
Description and use of squeue is same as :ref:`above <slurm_squeue>`.


Reporting usage 
----------------

On some KSL systems such as Shaheen III, there is a charging mechanism which allows usage to be deducted from the allocatable core hours approved by RCAC committee for a project PI. There are some SLURM utilities which can help in revealing the usage stats of a job even after it has concluded.

sacct
**********

``sacct`` displays accounting command which tell about the resources used by the job and its job steps.

.. code-block:: bash
    :caption: ``sacct`` use for understanding the usage statistics for a job

    > sacct -j 33204827
    JobID           JobName  Partition    Account   NNodes      State ExitCode 
    ------------ ---------- ---------- ---------- -------- ---------- -------- 
    33204827     test.slurm      workq        k01        1 CANCELLED+      0:0 


KSL in-house utilites
=====================

For users to conveniently query some common metrics, KSL system administration have developed utilities.

Query allocation balance on Shaheen III
--------------------------------------------

Using a command called ``sb``, users can check the status of their allocation on Shaheen III. In an example below, a user who is a member of project/group ``k01`` queries and gets a history of the allocation and its current balance.

.. code-block:: bash
    :caption: usage pattern of command ``sb``

    xyz123@cdl2:~> sb k01
    Project k01: KSL Computational Science Support
    PI: Professor Isaac Newton

    Allocations     Core hours
    --------------------------
    2015-06-25        50000000
    2015-11-18        50000000
    2015-11-18         1000000
    2015-12-01         5000000
    2015-12-03        50000000
    2016-01-04        50000000
    2016-01-18       200000000
    2016-01-24        50000000
    --------------------------
    Expiry on       2024-01-01
    --------------------------
    Allocated        456000000
    Shaheen          312348411
    --------------------------
    Balance          143651589
    --------------------------


Query storage quota Project Filesystem of Shaheen III
--------------------------------------------------------

Project filesystem provides persistent storage solution to Shaheen III users. The allocation on ``/project`` filesystem has quota for a project and members of that group share it. To query the status of a usage for a group the command ``kpq`` comes in handy.

.. code-block:: bash
    :caption: usage of command ``kpq``

    xyz123@cdl2> kpq k01
    Disk quotas for Isaac Newton (pid 1104):
        Filesystem    used   quota   limit   grace   files   quota   limit   grace
            /lustre  2.293T      0k     80T       -  461729       0       0       -
    pid 1104 is using default file quota setting
           /lustre2  52.97T      0k     80T       - 19126381       0       0       -

Note that the second line reporting the metrics related to ``/lustre2`` are reporting the usage of ``/scratch`` filesystem. 



Query status of GPUs on Ibex cluster
------------------------------------------

GPU compute nodes are allocated as shared among the users' jobs. To know the current status and availability of GPUs, KSL systems team has developed a useful utility aptly called ``ginfo``.

.. code-block:: bash
    :caption: querying availability of GPUs on Ibex cluster
    
    xyz123> ginfo
    GPU Model        Used    Idle   Drain    Down   Maint   Total
    a100              236      12       0       0       0     248
    gtx1080ti          46      18       0       0       0      64
    p100               17       3       0       0       0      20
    p6000               2       2       0       0       0       4
    rtx2080ti          12      12       0       0       0      24
    v100              240      26       0       0       0     266
           Totals:    553      73       0       0       0     626

