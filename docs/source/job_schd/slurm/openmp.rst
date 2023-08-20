OpenMP
----------------
A jobscript running an OpenMP code on a Ibex with 4 OpenMP threads 

.. code-block:: bash
   
    
    #!/bin/bash
    #SBATCH --time=00:10:00 
    #SBATCH --ntasks=1 
    #SBATCH --cpus-per-task=4
    module load gcc/6.4.0
    export OMP_NUM_THREADS=4 
    export OMP_PLACES=cores 
    export OMP_PROC_BIND=close srun –c 4 ./my_omp_application
 
   
