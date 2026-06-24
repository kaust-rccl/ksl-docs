.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Shaheen3 quickstart guide
    :keywords: shaheen3, quickstart

.. _quickstart_shaheen3:

==================================
Shaheen III GPU
==================================



For a quick reference on how to use Shaheen III GPU, kindly :download:`download Shaheen III GPU Flyer <ShaheenIII-GPU-flyer-2026-06-24.pdf>`

Shaheen III GPU Architecture
============================

The GPU partition consists of 7 cabinets, each populated with 50 HPE Cray EX254n blades.

Each blade contains two nodes, and each node integrates four NVIDIA GH200 Grace Hopper Superchips. Each GH200 combines a 72-core Grace CPU (Arm Neoverse V2) with an H100 Hopper GPU connected with NVLINK. The usable accessible memory in every GH200 is 95 GB of HBM3 and 120 GB of LPDDR5 memory, for a total of 860 GB of usable memory in each node. Each GH200 is connected to a switch through a 200 Gb/s Slingshot network port, for a total of 4 ports per node, and a maximum achievable bidirectional bandwidth of 800 Gb/s to other nodes.  

.. The GH200 architecture is described in detail here (photo of the GH200) 

GPU nodes are interconnected using HPE Slingshot 11 in a dragonfly topology, with 4 network ports per node. In total, the system includes 2,800 GH200 Superchips, achieving 122.8 PFlop/s of HPL performance. At the time of installation, this made the Shaheen III GPU system the fastest supercomputer in the Middle East and placed it among the world’s leading systems, ranking 18th on the Top500 list (November 2025). 

.. _quickstart_shaheen3_login:

How to Connect to Shaheen III GPUs
==================================

It is assumed that the reader has an account on Shaheen III GPUs. If not, the reader should send email to :email:`gpuhelp@hpc.kaust.edu.sa <gpuhelp@hpc.kaust.edu.sa>` for creating the account.  

For users with accounts, here are the steps for connecting to Shaheen III GPUs: 

#. Connect to ``hpc-vpn.kaust.edu.sa`` (if outside campus)
#. Open incognito session in a browser (e.g. Chrome)
#. Go to https://s3vdi.kaust.edu.sa
#. Click web client option (authenticate using ``s-xxxx@kaust.edu.sa``, password and Duo)
#. Click S3-VDI (authenticate again)
#. Open Terminal
#. ``ssh ulogin.hpc.kaust.edu.sa``
#. Type your password
#. ``ssh gh``
#. Type your password  

.. If you have any confusion, see the demo.

Now you are on the login node of Shaheen III GPU partition. You can compile and run the programs by following the guidance provided below. 

How to Submit
=============

On the Shaheen III GPU partition we use the same job scheduler (SLURM) as on the CPU partition. Therefore, the SLURM commands that work on the CPU partition work on the GPU partition as well. The only difference lies in the preparation of the SLURM jobscript, in which there are some settings that apply to the GPU partition only. Below is an example jobscript ``test.slurm`` for the GPU partition, where you can see an extra line ``#SBATCH --gres=gpu:4`` is used to request for GPU resources: 

.. code-block:: bash
    :caption: test.slurm

    #!/bin/bash
    #SBATCH --partition=workq
    #SBATCH --job-name=test
    #SBATCH --nodes=1
    #SBATCH --gres=gpu:4
    #SBATCH --time=24:00:00
    #SBATCH --err=std.err
    #SBATCH --output=std.out

    OMP_NUM_THREADS 
    srun --ntasks=4 --cpus-per-task=${OMP_NUM_THREADS} --cpu-bind=verbose --gpu-bind=verbose,map:0,1,2,3 --gres-flags=allow-task-sharing ./a.out 

Once the jobscript is ready, we can use ``sbatch`` to submit the job: 

.. code-block:: bash

    sbatch test.slurm 

Programming Environment
=======================

Environment Modules
-------------------

The following command can be used to see the available modules on the system: 

.. code-block:: bash

    module avail  

A module can be loaded as follows (e.g., the gromacs module): 

.. code-block:: bash

    module load gromacs 

The following will show the information about the module: 

.. code-block:: bash

    module show gromacs 

Compiler Toolchains
-------------------

Three programming environments are available for compiling source code:

* ``PrgEnv-cray``
* ``PrgEnv-gnu``
* ``PrgEnv-nvidia``

The following command can be used to switch between the programming environments: 

.. code-block:: bash

    module swap PrgEnv-cray PrgEnv-nvidia 

FAQs
====

User Support
------------

**Where can I get GPU technical support?**
  Please send an email to :email:`gpuhelp@hpc.kaust.edu.sa <gpuhelp@hpc.kaust.edu.sa>` for any GPU technical support related support.

**Where can I request GPU export control related questions?**
  Please send an email to :email:`ExportControls@kaust.edu.sa <ExportControls@kaust.edu.sa>`.

**Am I allowed to access GPUs from any country?**
  Please follow the GPU access policy guidance. For example, GPU access is restricted when you are travelling to D:5 countries (see the `U.S. Export Administration Regulations (EAR) Supplement No. 1 to Part 740 <https://www.ecfr.gov/current/title-15/subtitle-B/chapter-VII/subchapter-C/part-740/appendix-Supplement%20No.%201%20to%20Part%20740>`_).

**Where can I find some examples for submitting jobs?**
  See the section on how to submit jobs.

**Do you hold regular face to face sessions for users?**
  Each semester, there will be training sessions. You can also come to our "Coffee with Supercomputing sessions" (starting on the 3rd week of August).

**Can I simply use my Shaheen III CPU code on Shaheen III GPU and expect the code to run much faster?**
  No, the architecture is not the same. Unless the code is written for GPUs and optimized for GH200, it is unlikely that you will benefit from running your CPU-based workload on GPUs.

**Learning GPU programming is difficult for me. Can you tell me if I can still benefit from this enormous GPU resource?**
  You should consider transitioning your workload to a third-party code that is optimized for GPUs. Then you can simply experience speed-up and reduce time to solution for your work.

Access and Network Access
-------------------------

**When should the VPN connection method be used?**
  Use the VPN only when accessing the Shaheen III GPU Cluster from off-campus locations.

**Which campus Wi-Fi networks support Shaheen III access?**
  You can access the Shaheen III network on Uni-Fi or iCampus WLANs.

**Which campus buildings support direct wired (Ethernet) access?**
  Wired access is available through active data ports in the following campus buildings: Buildings 1, 2, 3, 4, 5, 9, 12, 14, and 18.

**Which operating systems are supported?**
  * Windows 11
  * macOS version 15 or newer
  * Ubuntu Linux version 22.04 or newer

Software Environment
--------------------

**What is the default environment?**
  ``PrgEnv-cray`` is the default one. Please do not purge the module.

Computing Resources
-------------------

**Which project am I assigned to?**
  Check the output of ``groups`` and ``id``.

**Can I allocate 1 GPU for my test jobs?**
  Shaheen III GPU partition provides exclusive node allocation. Hence, you will be allocating 4 GPUs for your job.

**What is the maximum number of nodes and the number of GPUs allocated per user?**
  *(TBD)*

Job Scheduling and Interactive Jobs
-----------------------------------

**How can I run Jupyter notebooks?**
  *(TBD)*

**Am I allowed to monitor the GPU utilization?**
  You may monitor your GPU jobs by using ``nvidia-smi``, for example.

**How can I use the VS-Code server in Shaheen III GPUs?**
  *(TBD)*

Storage and Quota
-----------------

**Am I allowed to run more than 1M files for my job? If so, what will be the best practice?**
  *(TBD)*

**What are the storage quotas and number of files limitations?**
  *(TBD)*

