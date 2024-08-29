.. sectionauthor:: Kadir Akbudak <kadir.akbudak@kaust.edu.sa>
.. meta::
    :description: Using NCO on Shaheen III
    :keywords: NCO

====================================
Using NCO on Shaheen III
====================================

The following SLURM job script file can be used to run NCO on Shaheen III:

.. code-block:: bash

    #!/bin/bash
    #SBATCH --nodes=1
    #SBATCH --hint=nomultithread
    #SBATCH --time=00:10:00
    module load singularity
    singularity run /scratch/reference/singularity_images/atmospheric_oceanic_sciences/nco_4.8.1.sif nc-config --all
