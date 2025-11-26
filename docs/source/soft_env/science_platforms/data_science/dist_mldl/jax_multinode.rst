.. sectionauthor:: Didier Barradas Bautista <didier.barradasbautista@kaust.edu.sa>
.. meta::
    :description: JAX Multi-node Distributed Training
    :keywords: jax, distributed training, multi-node, multi-gpu, singularity

.. _jax_multinode:

==========================================
JAX Multi-node Distributed Training
==========================================

JAX is a high-performance numerical computing library that provides composable transformations of Python+NumPy programs: differentiation, vectorization, parallelization, and JIT compilation. JAX's distributed training capabilities enable efficient scaling across multiple GPUs and nodes, making it ideal for large-scale machine learning workloads.

JAX supports data parallelism through its ``pmap`` function and ``jax.distributed`` module, which allow you to automatically distribute computations across multiple devices. This makes it straightforward to scale your training from a single GPU to multiple nodes with minimal code changes.


Why Use Singularity Containers for JAX?
========================================

Singularity containers provide several significant advantages for running JAX and managing your software environment on HPC systems:

**Reproducibility and Portability**
  Containers encapsulate your entire software stack, including JAX, CUDA libraries, Python dependencies, and system libraries. This ensures your code runs identically across different systems and over time, making research reproducible and eliminating "works on my machine" issues.

**Dependency Management Simplification**
  JAX has complex dependencies including CUDA, cuDNN, NCCL, and specific Python packages. Managing these dependencies manually can be challenging, especially when different projects require different versions. Containers isolate these dependencies, allowing you to maintain multiple JAX environments without conflicts.

**Performance Optimization**
  Pre-built JAX containers are optimized for HPC environments with the correct CUDA versions, NCCL configurations, and compiler flags. This ensures you get optimal performance without spending time on complex compilation and optimization tasks.

**Easy Version Control**
  You can maintain multiple container images for different JAX versions and switch between them effortlessly using environment modules. This is particularly useful when working on multiple projects or reproducing older results.

**System Independence**
  Containers run in user space without requiring root privileges, making them perfect for shared HPC environments. You can install and manage your own software stack without depending on system administrators or waiting for software installation requests.

**Seamless Multi-node Scaling**
  Singularity containers work seamlessly with SLURM and MPI, making distributed training across multiple nodes straightforward. The container ensures all nodes run identical software versions, eliminating version mismatch issues in distributed training.

By using Singularity containers, you gain full control over your software environment while maintaining reproducibility, portability, and optimal performance. This approach is strongly recommended for managing JAX and other complex ML/DL frameworks on HPC systems.


JAX on Ibex
==================

Setting up JAX with Singularity
---------------------------------

On Ibex, JAX is available as a Singularity container through the module system. This approach ensures optimal performance and compatibility with our HPC environment.

Loading JAX Module
^^^^^^^^^^^^^^^^^^

To use JAX, first load the required modules:

.. code-block:: bash
    
    module load dl
    module load jax/23.10-sif

This will set up the environment variables needed to run JAX within a Singularity container. The ``JAX_IMAGE`` environment variable will point to the optimized JAX container image.

Verifying Your Setup
^^^^^^^^^^^^^^^^^^^^^

You can verify your JAX setup by checking the available devices. Create a simple query script:

.. code-block:: python
    :caption: query_v1.py - Query JAX devices when each process has one GPU

    # Query the number of GPU devices such that each process per node has one GPU attached
    import jax
    import jax.numpy as jnp
    
    jax.distributed.initialize()
    
    print(f"# Local devices: [ {jax.local_device_count()} ], {jax.local_devices()}")
    print(f"# Global devices:[ {jax.device_count()}, {jax.devices()}")

For cases where each process manages multiple GPUs per node, use this variant:

.. code-block:: python
    :caption: query_v2.py - Query JAX devices when each process has multiple GPUs

    # Query the number of GPU devices such that each process per node has > 1 GPUs attached
    import os
    import jax
    import jax.numpy as jnp
    
    jax.distributed.initialize(
        num_processes=int(os.environ['SLURM_NTASKS']),
        local_device_ids=[x for x in range(int(os.environ['SLURM_GPUS_PER_NODE']))]
    )
    
    print(f"# Local devices: [ {jax.local_device_count()} ], {jax.local_devices()}")
    print(f"# Global devices:[ {jax.device_count()}, {jax.devices()}")


Running JAX Distributed Training
==================================

Single Node, Single Process per GPU
-------------------------------------

For a single node with 4 GPUs, where each process manages one GPU:

.. code-block:: bash
    :caption: G4N1p4.slurm - Single node with 4 GPUs, 4 processes (1 GPU per process)

    #!/bin/bash 
    
    #SBATCH --time=00:05:00
    #SBATCH --ntasks=4
    #SBATCH --tasks-per-node=4
    #SBATCH --cpus-per-task=4
    #SBATCH --gpus=4
    #SBATCH --gpus-per-node=4
    #SBATCH --constraint=a100
    
    scontrol show job ${SLURM_JOBID} 
    module load dl
    module load jax/23.10-sif
    
    export IMAGE=$JAX_IMAGE
    
    srun -u -n ${SLURM_NTASKS} -N ${SLURM_NNODES} singularity run --nv $IMAGE \
        python query_v1.py

**Expected Output:**

When you run this job, you should see output from 4 processes, each reporting one local device and 4 global devices:

.. code-block:: text

    # Local devices: [ 1 ], [cuda(id=0)]
    # Global devices:[ 4 ], [cuda(id=0), cuda(id=1), cuda(id=2), cuda(id=3)]

Each process has access to one GPU locally, but is aware of all 4 GPUs in the distributed setup.


Multi-node with Multiple GPUs per Process
-------------------------------------------

For distributed training across 2 nodes with 2 GPUs per node, where each process manages multiple GPUs:

.. code-block:: bash
    :caption: G4N2p2.slurm - Two nodes with 4 GPUs total, 2 processes (2 GPUs per process)

    #!/bin/bash 
    
    #SBATCH --time=00:05:00
    #SBATCH --ntasks=2
    #SBATCH --tasks-per-node=1
    #SBATCH --cpus-per-task=4
    #SBATCH --gpus=4
    #SBATCH --gpus-per-node=2
    #SBATCH --constraint=a100
    
    scontrol show job ${SLURM_JOBID} 
    module load dl
    module load jax/23.10-sif
    
    export IMAGE=$JAX_IMAGE
    
    srun -u -n ${SLURM_NTASKS} -N ${SLURM_NNODES} singularity run --nv $IMAGE \
        python query_v2.py

**Expected Output:**

With 2 nodes, 1 process per node, and 2 GPUs per process:

.. code-block:: text

    # Local devices: [ 2 ], [cuda(id=0), cuda(id=1)]
    # Global devices:[ 4 ], [cuda(id=0), cuda(id=1), cuda(id=2), cuda(id=3)]

Each process manages 2 local GPUs and is aware of all 4 GPUs globally.


Multi-node with Single GPU per Process
----------------------------------------

For a more traditional setup with 2 nodes, 2 processes per node (4 total), each managing one GPU:

.. code-block:: bash
    :caption: G4N2p4.slurm - Two nodes with 4 GPUs total, 4 processes (1 GPU per process)

    #!/bin/bash 
    
    #SBATCH --time=00:05:00
    #SBATCH --ntasks=4
    #SBATCH --tasks-per-node=2
    #SBATCH --cpus-per-task=4
    #SBATCH --gpus=4
    #SBATCH --gpus-per-node=2
    #SBATCH --constraint=a100
    
    scontrol show job ${SLURM_JOBID} 
    module load dl
    module load jax/23.10-sif
    
    export IMAGE=$JAX_IMAGE
    
    srun -u -n ${SLURM_NTASKS} -N ${SLURM_NNODES} singularity run --nv $IMAGE \
        python query_v1.py

**Expected Output:**

With 4 processes across 2 nodes, each managing 1 GPU:

.. code-block:: text

    # Local devices: [ 1 ], [cuda(id=0)]
    # Global devices:[ 4 ], [cuda(id=0), cuda(id=1), cuda(id=2), cuda(id=3)]

Each process has one local device but can coordinate with all 4 GPUs in the distributed training setup.


Distributed All-Reduce Example
================================

A common operation in distributed training is the all-reduce collective, which computes a reduction across all devices and broadcasts the result. Here's a practical example:

.. code-block:: python
    :caption: allreduce.py - Demonstrates distributed all-reduce operation using pmap

    import jax
    import jax.numpy as jnp
    
    jax.distributed.initialize()
    
    print(f"Total devices: {jax.device_count()}", " | ", 
          f"Devices per task: {jax.local_device_count()}")
    
    x = jnp.ones(jax.local_device_count())
    
    # Computes a reduction (sum) across all devices of x and broadcast the result, in y, to all devices.
    # If x=[1] on all devices and we have 8 devices, the expected result is y=[8] on all devices.
    
    y = jax.pmap(lambda x: jax.lax.psum(x, "i"), axis_name="i")(x)
    
    print(f"Process {jax.process_index()} has y={y}")


To run this example with 8 GPUs across 2 nodes:

.. code-block:: bash
    :caption: allreduce.slurm - Multi-node all-reduce example with 8 GPUs

    #!/bin/bash 
    
    #SBATCH --time=00:05:00
    #SBATCH --ntasks=8
    #SBATCH --tasks-per-node=4
    #SBATCH --cpus-per-task=4
    #SBATCH --gpus=8
    #SBATCH --gpus-per-node=4
    #SBATCH --constraint=a100
    
    scontrol show job ${SLURM_JOBID} 
    module load dl
    module load jax/23.10-sif
    
    export IMAGE=$JAX_IMAGE
    
    srun -n ${SLURM_NTASKS} -N ${SLURM_NNODES} singularity run --nv $IMAGE \
        python allreduce.py

**Expected Output:**

The all-reduce example will show each process reporting its local devices and the reduced result:

.. code-block:: text

    Total devices: 8  |  Devices per task: 1
    Process 0 has y=[8.]
    Total devices: 8  |  Devices per task: 1
    Process 1 has y=[8.]
    Total devices: 8  |  Devices per task: 1
    Process 2 has y=[8.]
    ...
    Total devices: 8  |  Devices per task: 1
    Process 7 has y=[8.]

Each process started with x=[1], and after the all-reduce sum operation, all processes have y=[8], which is the sum across all 8 devices.


Understanding JAX Distributed Training
========================================

Key Concepts
------------

**jax.distributed.initialize()**
  This function sets up the distributed environment, establishing communication between processes across nodes. It uses environment variables set by SLURM to determine the number of processes and device assignments.

**jax.pmap()**
  The ``pmap`` function parallelizes computation across devices. It maps a function across the first axis of the input, distributing the computation across available devices. This is the primary tool for data parallelism in JAX.

**Collective Operations**
  Operations like ``jax.lax.psum`` perform reductions across all devices. These are essential for synchronizing gradients during distributed training.

**Device Management**
  - ``jax.device_count()``: Total number of GPUs across all nodes
  - ``jax.local_device_count()``: Number of GPUs available to the current process
  - ``jax.process_index()``: Identifier for the current process in the distributed setup


Process and GPU Mapping Strategies
------------------------------------

When scaling JAX training, you have two main approaches:

**One Process per GPU** (Recommended for most cases)
  Each SLURM task manages a single GPU. This is simpler to configure and works well for most training scenarios. Use ``query_v1.py`` style initialization.

**Multiple GPUs per Process**
  Each SLURM task manages multiple GPUs. This can reduce communication overhead when processes are on the same node but requires explicit device ID mapping. Use ``query_v2.py`` style initialization with ``local_device_ids`` parameter.


Best Practices
---------------

1. **Load modules first**: Always load ``dl`` and ``jax/23.10-sif`` modules before running your scripts
2. **Use appropriate initialization**: Choose between ``query_v1.py`` or ``query_v2.py`` style based on your process-to-GPU mapping
3. **Match SLURM parameters**: Ensure ``--ntasks``, ``--gpus``, and ``--gpus-per-node`` are correctly configured for your desired setup
4. **Use srun**: Launch your Singularity container with ``srun`` to properly distribute processes across nodes
5. **Enable GPU support**: Always use ``--nv`` flag with Singularity to enable NVIDIA GPU support
6. **Monitor device counts**: Verify that ``jax.device_count()`` matches your expected total GPU count before running expensive training


Troubleshooting
================

**Issue**: JAX doesn't see all GPUs
  **Solution**: Verify your SLURM GPU allocation matches your initialization parameters. Check that ``jax.device_count()`` reports the expected number of devices.

**Issue**: Distributed initialization hangs
  **Solution**: Ensure all nodes can communicate. Check that SLURM environment variables are properly set. Try running the query scripts first to verify basic functionality.

**Issue**: CUDA out of memory errors
  **Solution**: Reduce batch size per device or use JAX's memory preallocation strategies. Remember each process has its own memory pool when using multiple processes per node.

**Issue**: Performance doesn't scale linearly
  **Solution**: Check that your batch size is large enough to benefit from distribution. Profile communication overhead using JAX profiling tools. Ensure your network interconnect (InfiniBand) is being used.


Additional Resources
=====================

- `JAX Documentation <https://jax.readthedocs.io/>`_
- `JAX Distributed Training Guide <https://jax.readthedocs.io/en/latest/multi_process.html>`_
- `Example Code Repository <https://github.com/kaust-rccl/Dist-DL-training/tree/master/jax>`_
- For questions or support, contact KSL at help@hpc.kaust.edu.sa
