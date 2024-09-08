.. sectionauthor:: Kadir Akbudak <kadir.akbudak@kaust.edu.sa>
.. meta::
    :description: Using wgrib2 on Shaheen III
    :keywords: wgrib2

====================================
Using wgrib2 on Shaheen III
====================================

The following SLURM job script file can be used to run wgrib2 on Shaheen III:

.. code-block:: bash

    #!/bin/bash
    #SBATCH --nodes=1
    #SBATCH --hint=nomultithread
    #SBATCH --time=00:10:00
    module load singularity
    singularity run /scratch/reference/singularity_images/atmospheric_oceanic_sciences/atmospheric-sciences_0.1.0.sif wgrib2
