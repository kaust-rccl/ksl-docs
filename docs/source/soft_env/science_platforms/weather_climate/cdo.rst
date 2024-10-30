.. sectionauthor:: Kadir Akbudak <kadir.akbudak@kaust.edu.sa>
.. meta::
    :description: Using CDO on Shaheen III
    :keywords: CDO

====================================
Using CDO on Shaheen III
====================================

The following SLURM job script file can be used to run CDO on Shaheen III:

.. code-block:: bash

    #!/bin/bash
    #SBATCH --nodes=1
    #SBATCH --hint=nomultithread
    #SBATCH --time=00:10:00
    module load singularity
    singularity run /scratch/reference/singularity_images/atmospheric_oceanic_sciences/cdo_gnu_1.9.10.sif cdo --version
