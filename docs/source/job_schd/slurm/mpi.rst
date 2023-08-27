MPI
----------------
A jobscript running MPI code on Ibex with 32 MPI tasks on same
node


.. code-block:: bash
   
    #!/bin/bash
    #SBATCH --time=00:10:00
    #SBATCH --ntasks=32
    #SBATCH --tasks-per-node=32
    module load openmpi/4.0.3
    module load gcc/11.2.2
    mpirun -n 32 ./my_mpi_application