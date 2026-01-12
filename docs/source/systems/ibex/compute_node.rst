.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Compute nodes on Ibex
    :keywords: CPUs, GPUs, Shaheen III, Ibex, Compute nodes
    
.. _ibex_compute_nodes:

==============
Compute Nodes
==============

Compute nodes are the HPC optimized servers where the job scheduler schedules the jobs and runs it on users' behalf.  
Ibex cluster is composed of the compute nodes of various microarchitectures of CPUs and GPUs e.g. Intel Cascade Lake, Skylake, AMD Rome, NVIDIA RTX2080ti, V100, A100 etc.
The allocatable resource include CPU cores or GPUs, CPU memory, local fast storage on a node and duration or wall time.

The heterogeneity of compute nodes allow users to submit various types of applications and workflows. At times, Ibex becomes a defacto choice for workflows those are not suitable to run on other KSL systems. 
Users should submit CPU jobs from `ilogin` and GPU jobs from `glogin` login nodes. 


CPU Compute nodes
==================

Ibex has multiple CPU architectures available in different compute nodes. A single compute node, however, is always homogeneous in the CPU architecture. These CPU compute nodes different in the processor architecture, the memory capacity and other features such as availability of local disk or large memory capacity. 

If you wish to understand more about the available processors types and their features, please see :ref:`cpu_arch_tech_article` .

All CPU nodes are connected to the :ref:`HDR 100 Infiniband <ibex_interconnect>` high speed network with a theoretical peak of 100 gigabits per second (or 12.5GB/s). Also, each compute node has access to the shared parallel filesystem and home filesystem. More technical information please refer to :ref:`ibex_filesystems` section.

The table below summarizes the CPU nodes available in Ibex cluster. The values in constraint column suggests how to specific a type of compute node in your SLURM jobs. For more details on how to do this, please see :ref:`ibex_cpu_jobs` section for Ibex. 

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
     - local Storage
     - SLURM constraints
   * - Intel Cascade Lake
     - cascadelake
     - 18
     - 48
     - 4.20
     - 32
     - 3TB  
     - 6TB
     - intel, largemem, cascadelake
   * - Intel Skylake
     - skylake
     - 4
     - 32
     - 3.70
     - 32
     - 3TB
     - 10TB
     - intel, largemem, skylake
   * - Intel Sapphire Rapids
     - sapphire rapids
     - 8
     - 128
     - 4.1
     - 64
     - 8TB
     - 0.7TB
     - lm8TB  
   * - Intel Sapphire Rapids
     - sapphire rapids
     - 1
     - 128
     - 4.1
     - 64
     - 16TB
     - 0.7TB
     - lm16TB 


For submitting a job to a particular compute node, a set of constraints must be used to help SLURM pick the correct one. Users can either add them to your jobscript as a SLURM directive or pass it as command line argument to `sbatch` command.

.. code-block:: bash
    :caption: When submitting a job, the user is able to select the desired resources with precise constraints. For example,

    sbatch --constraint="intel&cascadelake" jobscript.slurm

The above specifies to SLURM that the job should run on an Intel Cascade Lake node. 

GPU Compute Nodes
===================

There are GPU nodes in Ibex cluster with GPUs of different microarchitecture.
Note that all the GPUs on a single node are always of the same microarchitecture, there is no heterogeneity there. 

At present all GPUs in Ibex cluster are by NVIDIA. All compute nodes with GPUs have multiple GPUs, minimum of 4 and maximum of 8. 

If you are new to using GPUs or would like to refresh your understanding about how a GPU works, then :ref:`gpu_basics_tech_article` is a good article to start with. It is a common place to compare the performance and software capabilities of available GPUs and match them with the bounds of your application to the appropriate one for your jobs. If you have questions about which GPU to use, please :email:`contact KSL support staff <help@hpc.kaust.edu.sa>` for guideline. 

All GPU nodes on Ibex cluster are connected to the :ref:`HDR Infiniband <ibex_interconnect>`. Some nodes are capable of achieving 200 gigabits per second or 25GB/s (e.g. nodes with A100 GPUs) and the other are connects via 100 gigabits per second (12.5GB/s). Some have more Network Interface Cards (NICs) than the others. With more NICs on these compute nodes, the aggregate bandwidth for operations such as GPU Direct RDMA will be higher when using multiple GPUs on each node. 

Also, each compute node has access to the shared parallel filesystem and home filesystem. More technical information please refer to :ref:`ibex_filesystems` section.

The table below summarizes the GPU nodes available in Ibex cluster. The values in constraint column suggests how to specific a type of compute node in your SLURM jobs. For more details on how to do this, please see :ref:`ibex_gpu_jobs` section.

.. _ibex_gpu_1_compute_nodes:
.. list-table:: **GPU Compute nodes in Ibex cluster**
   :widths: 15 15 15 10 10 10 10 15 10 10 10  
   :header-rows: 1

   * - Model
     - GPU Arch
     - Host CPU
     - Nodes
     - GPUs/ node
     - Cores/ node
     - GPU Mem
     - GPU Mem type
     - CPU Mem
     - GPU Clock (GHz)
     - CPU Clock (GHz)
   * - P6000
     - Pascal
     - Intel Haswell
     - 3
     - 2
     - 36(34)
     - 24GB
     - GDDR5X
     - 256GB
     - 1.5
     - 2.3
   * - P100
     - Pascal
     - Intel Haswell
     - 5
     - 4
     - 36(34)
     - 16GB
     - HBM2
     - 256GB
     - 1.19
     - 2.3
   * - GTX-1080Ti
     - Pascal
     - Intel Haswell
     - 8
     - 4
     - 36(34)
     - 11GB
     - GDDR5X
     - 256GB
     - 1.48
     - 2.3
   * - GTX-1080Ti
     - Pascal
     - Intel Skylake
     - 4
     - 8
     - 32(30)
     - 11GB
     - GDDR5X
     - 256GB
     - 1.48
     - 2.6
   * - RTX-2080Ti
     - Turing
     - Intel Skylake
     - 3
     - 8
     - 32(30)
     - 11GB
     - GDDR6
     - 383G
     - 1.35
     - 2.6
   * - V100
     - Volta
     - Intel Skylake
     - 6
     - 4
     - 32(30)
     - 32GB
     - HBM2
     - 383G
     - 1.29
     - 2.6
   * - V100
     - Volta
     - Intel Cascade Lake
     - 1
     - 2
     - 40(38)
     - 32GB
     - HBM2
     - 383G
     - 1.23
     - 2.5
   * - V100
     - Volta
     - Intel Cascade Lake
     - 30
     - 8
     - 48(46)
     - 32GB
     - HBM2
     - 383G
     - 1.29
     - 2.6
   * - A100
     - Ampere
     - AMD Milan
     - 46
     - 4
     - 64(62)
     - 80GB
     - HBM2
     - 512G
     - 1.16
     - 1.99
   * - A100
     - Ampere
     - AMD Milan
     - 8
     - 8
     - 128(126)
     - 80GB
     - HBM2
     - 1T
     - 1.16
     - 1.5

.. note::
  **Allocatable cores per node on GPU compute nodes** are less than the total available in hardware. Ibex cluster uses two cores per node to run high performance shared parallel filesystem called WekaIO. On compute nodes with V100 and A100 GPUs, these are pinned cores whereas on others, they are float (i.e. weka process will take precedence on cores 1 and 2). SLURM scheduler can allocate a maximum number of cpu cores per node as listed in parenthesis in column 6 **Cores/node** in the table above.   


Some additional details about the compute nodes with GPUs is necessary to know when choose them to run your jobs. The following table describes the maximum possible CUDA capability the GPU will work on, the interconnect between GPUs on the same node, and between CPUs and GPUs. Also listed is the whether the node is capable of GPU Direct RDMA, which by-passes the need of CPUs when communicating with a GPU of a different compute node in Ibex cluster. In addition to the parallel filesystem, some compute nodes have storage available which is local to the compute node.  

.. _ibex_gpu_2_compute_nodes:
.. list-table:: **CUDA capability, networking and filesystem information about GPU compute nodes in Ibex cluster**
   :widths: 20 15 20 15 15 15 20 30 30
   :header-rows: 1

   * - GPU Arch
     - GPUs/node
     - CUDA Cap
     - GPU-GPU
     - CPU-GPU
     - NICs
     - GDRDMA
     - local storage
     - SLURM constraints
   * - P6000
     - 2
     - 6.0
     - PCIe
     - PCIe
     - 1
     - IB
     - 400G
     - p6000 
   * - P100
     - 4
     - 6.0
     - PCIe
     - PCIe
     - 1
     - IB
     - 70G
     - p100
   * - GTX-1080Ti
     - 4
     - 6.1
     - PCIe
     - PCIe
     - 1
     - IB
     - 70G
     - gtx1080ti & cpu_intel_e5_2699_v3
   * - GTX-1080Ti
     - 8
     - 6.1
     - PCIe
     - PCIe
     - 1
     - IB
     - 700G
     - gtx1080ti & cpu_intel_gold_6142
   * - RTX-2080Ti
     - 8
     - 7.5
     - PCIe
     - PCIe
     - 1
     - IB
     - 700G
     - rtx2080ti
   * - V100
     - 4
     - 7.0
     - NVLink2.0
     - PCIe
     - 1
     - IB
     - 400G
     - v100, cpu_intel_gold_6142
   * - V100
     - 2
     - 7.0
     - PCIe
     - PCIe
     - 1
     - IB
     - 400G
     - v100, cpu_intel_gold_6248
   * - V100
     - 8
     - 7.0
     - NVLINK 2.0
     - PCIe
     - 4
     - IB
     - 7TB
     - v100, cpu_intel_platinum_8260, gpu_ai
   * - A100
     - 4
     - 8.0
     - NVLINK 3.0
     - PCIe
     - 2
     - IB
     - 5TB
     - a100, 4gpus
   * - A100
     - 8
     - 8.0
     - NVLINK 3.0
     - PCIe
     - 4
     - IB
     - 11TB
     - a100, 8gpus

