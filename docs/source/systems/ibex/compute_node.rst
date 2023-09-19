==============
Compute Nodes
==============

Compute nodes are the HPC optimized servers where the job scheduler schedules the jobs and runs it on users' behalf.  
Ibex cluster is composed of the compute nodes of various microarchitectures of CPUs and GPUs e.g. Intel Cascade Lake, Skylake, AMD Rome, NVIDIA RTX2089ti, V100, A100 etc.
The allocatable resource include CPU cores or GPUs, CPU memory, local fast storage on a node and duration or wall time.

The heterogeneity of compute nodes allow users to submit various types of applications and workflows. At times, Ibex becomes a defacto choice for workflows those are not suitable to run on other KSL systems. 
Users should submit CPU jobs from `ilogin` and GPU jobs from `glogin` login nodes. 


CPU Compute nodes
==================
Described below are the CPU microarchitectures available in Ibex cluster.

Intel Skylake
--------------
Ibex cluster has 106 compute nodes of with Intel Skylake processors. These are the oldest generation of Intel CPUs in the cluster at the moment. 
These nodes have two Intel Skylake processors, one in each socket, represented as *Package* in the :ref:`ibex_skylake`. 
Each processes has 20 physical cores, i.e. 40 cores in total on the node. 
The total memory available for use is approximately 350GB/s and has 6 memory channels per socket.

.. _ibex_skylake:
.. figure:: ../static/skylake.svg
  :alt: Illustration of an Intel Skylake compute node of Ibex cluster
  
  Illustration of an Intel Skylake compute node of Ibex cluster

This node has two Non Uniform Memory Access (NUMA) nodes. This implies that `core 0` can access data resident on a memory device/DIMM closed to Package L#1, but will have a latency hit. Deep dive to understand more about :ref:`NUMA architecture <numa_tech_article>` and its implications on applications running on such node. 

The L3 or *Last Level Cache* is coherent across all the nodes which implies that if a `core` changes a memory location in L3, it will be visible to all cores. This does not apply to L1 and L2 caches which are local to each core. More discussion :ref:`here on Memory hierarchy on CPUs <memory_hierarchy_cpu_tech_article>`.
 
The motherboard on this node have PCIe version 3.0 which has a maximum overall throughput of 32GB/s.

From a performance point of view, this node is capable of achieving, **### GFLOPS** of `High Performance Linpack (HPL) <https://www.top500.org/project/linpack/>`_ and a peak memory bandwidth of **### GB/s** measured using `STREAM Triad <https://www.cs.virginia.edu/stream/ref.html>`_ benchmark.

These processors can run programs compiled for `x86_64` instruction set. Intel Skylake processor supports `Advance Vector Extension -- AXV2` instructions for vectorization. Some scientific applications can benefit from this feature and can see significant performance gains. Please refer to :ref:`Understanding SIMD Vectorization <vectorization_cpu_tech_article>` for more information about this topic. 


Intel Cascade Lake
------------------
Ibex cluster has 106 compute nodes of with Intel Cascade Lake processors. These are the more modern generation compared to Skylake CPUs.  
Each node of this type has two Intel Cascade Lake processors, one in each socket, represented as *Package* in the :ref:`ibex_cascadelake`. 
Each processes has 20 physical cores, i.e. 40 cores in total on the node. 
The total memory available for use is approximately 350GB/s and has 6 memory channels per socket.  

.. _ibex_cascadelake:
.. figure:: ../static/cascadelake.svg
  :alt: Illustration of an Intel Cascade Lake compute node of Ibex cluster
  
  Illustration of an Intel Cascade Lake compute node of Ibex cluster

As in the case of Skylake these nodes have 2 NUMA nodes. Here too, the L3 cache is coherent among all cores. 

The motherboard on this node have PCIe version 3.0 which has a maximum overall throughput of 32GB/s.

There nodes are capable of achieving **### GFLOPS** of `High Performance Linpack (HPL) <https://www.top500.org/project/linpack/>`_ and a peak memory bandwidth of **### GB/s** measured using `STREAM Triad <https://www.cs.virginia.edu/stream/ref.html>`_ benchmark.

Intel Cascade Lake supports AVX2 and some AVX512 instruction sets. Additionally, Cascade Lake processors introduced a specialized instruction set called **Vectorized Neural Network Instructions (VNNI)** which accelerates neural network inference on CPUs. Developers can leverage these features by relying on using Intel MKL-DNN, Intel optimized PyTorch or Tensorflow installations. 

AMD Rome 
---------
Ibex cluster has 108 nodes with dual socket AMD Rome processors. 
The microarchitecture of AMD Rome is different than the Intel processors mentioned above. This has performance implications which the users might want to consider when choosing to run applications on these processors. 

.. _ibex_amd_rome_ccd:
.. figure:: ../static/AMD-rome-ccd.png
  :alt: CCD design of AMD Rome processors 

  CCD design of AMD Rome processors

AMD Rome processor is composed of a compute unit called *Core CompleX (CCX)*. A single CCX is composed of 4 cores. 2 CCX units create a building block called a *Core Complex Die (CCD)*. This CCD block (i.e. 8 cores) has its own L1 to L3 cache hierarchy. Each CCD has a 32MB large L3 cache. 8 CCDs make up a full processor, with 64 cores and aggregate L3 cache of 256MB. 

Additionally, each CCD has a specialized communication unit called *Infinity fabric* which provides means to access memory. There are a total of 8 memory channels (1 per CCD). For superior memory access performance, these nodes on Ibex have been booted with 8 NUMA nodes (4 NUMA per processor). 

.. figure:: ../static/amd_rome.svg
  :alt: Illustration of an AMD Rome compute node on Ibex cluster

  Illustration of an AMD Rome compute node on Ibex cluster

The AMD Rome compute nodes have a total of 128 cores, as it is dual socket (2 x processors) and 475GB of usable memory. The motherboard on this node have PCIe version 4.0 which has a maximum overall throughput of 64GB/s.

Summary of CPU compute nodes 
-----------------------------

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

Some nodes have larger memory for workloads which require loading big data in memory, e.g. some bioinformatics workloads, or data processing/wrangling creating input data for Machine Learning and Deep Learning training jobs.   

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

GPU Compute Nodes
===================

There are GPU nodes in Ibex cluster with GPUs of different microarchitecture.
Note that all the GPUs on a single node are always of the same microarchitecture, there is no heterogeneity there. 

At present all GPUs in Ibex cluster of NVIDIA. 


Pascal P6000
-------------------

Pascal P100 
-------------------

Pascal GTX 1080 Ti 
------------------- 


Turning RTX 2080 Ti 
--------------------

Volta V100
-----------

Ampere A100 
------------


Summary of GPU compute nodes 
-----------------------------




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

   The allocation of CPU memory can be done with `--mem=###G` constraint in SLURM job scripts. The amount of memory depends on the job characterization. A good starting place would be at least as much as the GPU memory they will use. For example: 2 x v100 GPUs would allocate at least `--mem=64G` for the CPUs.

  
.. note::

   The glogin node has a single **NVIDIA Quadro K6000** (CC=3.5) GPU for compilation of the source code.

* The usable node memory represents the available memory for job execution.

More on Slurm Constraints
--------------------------

"**ref_32T**" and "**gpu_ai**" are used to differentiate the newer generation of the V100 GPU nodes from the old ones.
The new nodes have 32TB of NVMes as local storage. And some ML reference DBs have been copied to those NVMes to enhance jobs performance instead of using the shared BeeGFS scratch.

Slurm Partition
--------------------------

Continuous efforts has been made for fair share allocation of resources on Ibex, the following partitions has been implemented seamlessly to our users.

**gpu_wide** for jobs with 4+ gpus per node

**gpu_wide24** wide jobs with time limit less than 24 hours

**gpu4** for short GPU jobs (less than 4 hours)

.. note::

   Users can't specify those partitions in their scripts. This is done automatically by SLURM.

Large Memory
--------------------------

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
