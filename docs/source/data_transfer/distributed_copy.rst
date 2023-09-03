Distributed Copy
----------------
``dcp`` or distributed copy is a MPI-based copy tool developed by Lawrance Livermore National Lab (LLNL) as part of their ``mpifileutils`` suite. We have installed it on Shaheen. Here is an example jobscript to launch a data moving job with ``dcp``:

.. code-block:: bash

     #!/bin/bash

     #SBATCH --ntasks=4
     #SBATCH --time=01:00:00
     #SBATCH --hint=nomultithread
     
     module load mpifileutils
     time srun -n ${SLURM_NTASKS} dcp --verbose --progress 60 --preserve /path/to/source/directory /path/to/destination/directory

The above script launches ``dcp`` in parallel on with 4 MPI processes. ``--progress 60`` implies that the progress of the operation will be reported every 60 seconds.  ``--preserve`` implies that the ACL permissions, group ownership, timestamps and extended attributes will be preserved on the files the destination directory as were in parent/source directory.
