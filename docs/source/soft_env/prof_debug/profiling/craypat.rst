.. sectionauthor:: Kadir Akbudak <kadir.akbudak@kaust.edu.sa>
.. meta::
    :description: Cray Performance Measurement and Analysis Tools (CrayPat)
    :keywords: craypat


#########################################################
Cray Performance Measurement and Analysis Tools (CrayPat)
#########################################################

CrayPAT offers thorough data on how well an application performs. It can be used for hardware performance counter-based analysis, tracing, and profiling. It also gives users access to numerous user interfaces that let them access the experiment and reporting features, as well as a large selection of performance experiments that assess how much resource an executable program uses while it is executing.

Sampling experiment
===================

* Load the modules.

.. code-block:: bash

 module load perftools-base
 module load perftools-lite
 module rm darshan

* Build the application as usual.

* Copy the following commands in to a file named `job.slurm`. **Please add the partition and account in the batch script if necessary.**

.. code-block:: bash

 #!/bin/bash

 #SBATCH -t 30
 #SBATCH -N 1

 # Change the name of the perftools experiment file/directory
 export PAT_RT_EXPDIR_NAME=expfile.${CRAYPAT_LITE}.${SLURM_JOBID}

 time srun -n 8 /path/to/myexecutable.exe > my_output.${CRAYPAT_LITE}.${SLURM_JOBID} 2>&1

* Launch the application.

.. code-block:: bash

 sbatch job.slurm

* Inspect the program output `my_output.lite-samples.*`.

* More information can be retrieved with

.. code-block:: bash

 pat_report -o myrep.sample.rpt expfile.lite-samples.*

* `myrep.sample.rpt` contains the performance report.





.. toctree::
   :titlesonly:
   :maxdepth: 1
   :hidden:


