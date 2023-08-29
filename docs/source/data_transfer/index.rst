.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Data transfer utilities and resources on KSL systems
    :keywords: scp, dcp, globus, rsync, data-movers, podman

==============================
Data Transfer 
==============================
Motivation
^^^^^^^^^^
Sometimes it is needed to copy large number of files from ``/scratch`` to ``/project`` or vice versa. Both ``cp`` and ``rsync`` are convenient but sometimes you need speed to do such task.

Distributed Copy
^^^^^^^^^^^^^^^^
``dcp`` or distributed copy is a MPI-based copy tool developed by Lawrance Livermore National Lab (LLNL) as part of their ``mpifileutils`` suite. We have installed it on Shaheen. Here is an example jobscript to launch a data moving job with ``dcp``:

.. code-block:: bash

     #!/bin/bash

     #SBATCH --ntasks=4
     #SBATCH --time=01:00:00
     #SBATCH --hint=nomultithread
     
     module load mpifileutils
     time srun -n ${SLURM_NTASKS} dcp --verbose --progress 60 --preserve /path/to/source/directory /path/to/destination/directory

The above script launches ``dcp`` in parallel on with 4 MPI processes. ``--progress 60`` implies that the progress of the operation will be reported every 60 seconds.  ``--preserve`` implies that the ACL permissions, group ownership, timestamps and extended attributes will be preserved on the files the destination directory as were in parent/source directory.
