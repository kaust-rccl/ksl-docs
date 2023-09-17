Compute Nodes
==============

Compute nodes are the HPC optimized servers where the job scheduler schedules the jobs and runs it on users' behalf.  
Ibex cluster is composed of the compute nodes of various microarchitectures of CPUs and GPUs e.g. Intel Cascade Lakes, Skylakes, AMD Rome, NVIDIA RTX2089ti, V100, A100 etc.
The allocatable resource include CPU cores or GPUs, CPU memory, local fast storage on a node and duration or wall time.

The heterogenity of compute nodes allow users to submit various types of applications and workflows. At times, Ibex becomes a defacto choice for workflows those are not suitable to run on other KSL systems. 
Users should submit CPU jobs from `ilogin` and GPU jobs from `glogin` login nodes. Described below are the microarchitecture features of various generations of CPUs and GPUs in Ibex cluster.

Intel Skylake
--------------
Ibex cluster has 106 compute nodes of with Intel Skylake processors. These are oldest generation of Intel CPUs in the cluster at the moment. 

These nodes have two Intel Skylake processors, one in each socket. Each processes has 20 physical cores, i.e. 40 cores in total on the node. 
The total memory available for use is approximately 350GB/s.  

.. image:: ../static/skylake.svg

Line separator


.. image:: ../static/cascadelake.svg

Line separator

.. image:: ../static/amd_rome.svg


The table below summarizes the CPU nodes available in Ibex cluster. The values in constraint column suggests how to specific a type of compute node in your SLURM jobs. For more details on how to do this, please see :ref:`job templates <ibex_job_template>` section for Ibex. 

.. _ibex_cpu_compute_nodes:
.. list-table:: **CPU Compute nodes in Ibex cluster**
   :widths: 40 20 15 15 15 15 20 30 20
   :header-rows: 1

   * - CPU Family
     - CPU
     - Nodes
     - Cores/node
     - Clock (GHz)
     - FLOPS
     - Memory
     - SLURM constraints
     - local storage
   * - Intel Skylake
     - skylake
     - 106
     - 40
     - 2.60
     - 32
     - 350GB
     - intel, skylake
     - 744GB
   * - Intel Cascade Lake
     - cascadelake
     - 106
     - 40
     - 2.50
     - 32
     - 350GB
     - intel, cascadelake
     - 744GB
   * - AMD Rome
     - Rome
     - 108
     - 128
     - 2.00
     - 32
     - 475GB  
     - amd, rome
     - 744GB

Some nodes have larger memory for workloads which require loading big data in memory, e.g. some bioinformatic workloads, or data processing/wrangling creating input data for Machine Learning and Deep Learning training jobs.   

.. _ibex_largemem_compute_nodes:

.. list-table:: **Large memory Compute nodes in Ibex cluster**
   :widths: 40 20 15 15 15 15 20 30 20
   :header-rows: 1

   * - CPU Family
     - CPU
     - Nodes
     - Cores/node
     - Clock (GHz)
     - FLOPS
     - Memory
     - SLURM constraints
     - local SSD
   * - Intel Cascade Lake
     - cascadelake
     - 18
     - 48
     - 4.20
     - 32
     - 3TB  
     - intel, largemem, cascadelake
     - 6TB
   * - Intel Skylake
     - skylake
     - 4
     - 32
     - 3.70
     - 32
     - 3TB  
     - intel, largemem, skylake  
     - 10TB


For submitting a job to a particular compute node, a set of constraints must be used to help SLURM pick the correct one. Users can either add them to your jobscript as a SLURM directive or pass it as command line argument to `sbatch` command.

.. code-block:: bash
    :caption: When submitting a job, the user is able to select the desired resources with precise constraints. For example,

    sbatch --constraint="intel&cascadelake" jobscript.slurm

The above specifies to SLURM that the job should run on an Intel Cascade Lake node. 

**GPUs**
========
The IBEX cluster contains different architectures of GPUs like **Turing, Pascal and Volta**. These GPUs are further described below for your source code compilation and job submission.

The IBEX cluster has **62** GPU compute nodes (**392 GPU cards**)  and it's summarized in **Table 1**. These various GPUs are accessed by the SLURM scheduling using the constraints "**- -gres=gpu:GPUTYPE:x**", where x is for number of GPUs.

For example, "--gres=gpu:gtx1080ti:4" allocates 4 GTX GPUs.

 **Table 2. List of GPU architectures in IBEX Cluster**
 
+-----+--------------+-----------+----------------+------------+----------+--------------------------+
| Sl. | GPU          | Available | Available      | GPU        | Usable   | Constraint               |
| No  | Architecture | GPU cards | number of      | Memory     | Node     | for (SLURM)              |
|     |              | per node  | nodes          | (per card) | Memory   | scheduling               |
+=====+==============+===========+================+============+==========+==========================+
| 1   | Turning:     | 8         | 4              | 12GB       | 350GB    | "--gres=gpu:rtx2080ti:1" |
|     | rtx2080ti    |           |                |            |          |                          |
+-----+--------------+-----------+----------------+------------+----------+--------------------------+
| 2   | Pascal:      | 4 or 8    | 12             | 12GB       | 230GB or | "--gres=gpu:gtx1080ti:1" |
|     | gtx1080ti    |           | (4*8 and 8*4)  |            | 350GB    |                          |
+-----+--------------+-----------+----------------+------------+----------+--------------------------+
| 3   | Pascal:      | 4         | 5              | 16GB       | 230GB    | "--gres=gpu:p100:1"      |
|     | p100         |           |                |            |          |                          |
+-----+--------------+-----------+----------------+------------+----------+--------------------------+
| 4   | Pascal:      | 2         | 2              | 22GB       | 230GB    | "--gres=gpu:p6000:1"     |
|     | p6000        |           |                |            |          |                          |
+-----+--------------+-----------+----------------+------------+----------+--------------------------+
| 5   | Volta:       | 4 or 8    | 37 (1*2 and    | 32GB       | 340GB or | "--gres=gpu:v100:1"      |
|     | v100         |           | 6*4 and 30*8)  |            | 712GB    |                          |
+-----+--------------+-----------+----------------+------------+----------+--------------------------+
| 6   | Ampere:      | 4 or 8    | 52             | 80GB       | 500GB or | "--gres=gpu:a100:1"      |
|     | a100         |           | (44*4 and 8*8) |            | 1TB      | "--reservation=A100"     |
+-----+--------------+-----------+----------------+------------+----------+--------------------------+

.. note::

   The allocation of CPU memory can be done with `--mem=###G` constraint in SLURM job scripts. The amount of memory depends on the job characteristization. A good starting place would be at least as much as the GPU memory they will use. For example: 2 x v100 GPUs would allocate at least `--mem=64G` for the CPUs.

.. note::

   The glogin node has a single **NVIDIA Quadro K6000** (CC=3.5) GPU for compilation of the source code.

* The usable node memory represents the available memory for job execution.

**More on Slurm Constraints:**
******************************
"**ref_32T**" and "**gpu_ai**" are used to differentiate the newer generation of the V100 GPU nodes from the old ones.
The new nodes have 32TB of NVMes as local storage. And some ML reference DBs have been copied to those NVMes to enhance jobs performance instead of using the shared BeeGFS scratch.

**Slurm Partition:**
********************
Continuous efforts has been made for fair share allocation of resources on Ibex, the following partitions has been implemented seamlessly to our users.

**gpu_wide** for jobs with 4+ gpus per node

**gpu_wide24** wide jobs with time limit less than 24 hours

**gpu4** for short GPU jobs (less than 4 hours)

.. note::

   Users can't specify those partitions in their scripts. This is done automatically by SLURM.

**Large Memory**
================
The IBEX cluster has a total of 18 Skylake and Cascadelake large memory nodes 2.93 TB each. However, part of the memory is used by operating system and remaining memory is usable for the job execution. The summary of large memory nodes are listed in the below table:   
   
        **Table 3. Ibex Large Memory Nodes**

+---------------------+----------------+-----------------+---------------------------------+
| System architecture | Cores per node | Number of nodes | Recommended max memory per node |
+=====================+================+=================+=================================+
| Intel Skylake       | 32             | 4               | 2.93 TB                         |
+---------------------+----------------+-----------------+---------------------------------+
| Intel Cascadelake   | 48             | 14              | 2.93 TB                         |
+---------------------+----------------+-----------------+---------------------------------+ 

* The usable node memory represents the available memory for job execution.

The jobs with the larger memory requirement can be submitted using  `--mem=###G` constraint in SLURM job scripts. For jobs to run on a large memory node they must request at least **370,000MB** of memory. For any job that requests less than **370,000MB** it'll be classified as a normal compute job and will run on a normal compute node.

For further info or send us a query using the :ref:`Contact Us<Contact_Us>` page.

Alternatively, send an email to ibex@hpc.kaust.edu.sa.

For more information on how to apply constraints, check the page Setting up job constraints , and the :ref:`Ibex Jobscript Generator <jobscript_generator>`