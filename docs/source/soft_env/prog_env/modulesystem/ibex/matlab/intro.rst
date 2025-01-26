.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Matlab on Ibex
    :keywords: Ibex, Matlab

.. _matlab_on_ibex:

===============================
Using Matlab on Ibex
===============================

Getting Access
---------------

In order to use Matlab, the user needs to be added to the ksl-matlab group.

MATLAB is a licensed software and the access of this software is controlled via Shaheen. In order to grant the MATLAB access, the user
account needs to be created an Shaheen (although you will not use it) and the procedure is as follows:

- Submit the application form `this website: <https://apply.hpc.kaust.edu.sa>`_ along with a scanned copy of your passport and KAUST ID.
- The form needs to be signed by your PI in the section at the top of page.
- Leave the project sections blank as you will not be logging into the Shaheen system.
- Fill in the mentioned form and send it to help@hpc.kaust.edu.sa requesting the access to the Matlab group.

After confirming, the user will be added to “ksl-matlab” user group to use Matlab on Ibex.

You can start using Matlab in either interactive mode for debugging and general use or batch mode to run premade scripts.

Interactive Mode
-----------------

First, login to CPU or GPU node based on your requirements.

.. code-block:: bash

    ssh -X username@ilogin.ibex.kaust.edu.sa

or

.. code-block:: bash

    ssh -X username@glogin.ibex.kaust.edu.sa


Then, allocate an interactive node with the required wall-clock time.

For example:

.. code-block:: bash

    srun -N 1 --ntasks=4 -t 01:00:00 --pty /bin/bash -l



Use the MATLAB software module and select the required version.

.. code-block:: bash

    module avail matlab # To check the available versions on the system


.. code-block:: bash

    module load matlab/R2023b # Use the specific version of MATLAB

To run the Matlab

.. code-block:: bash

    matlab

.. note::

    To be able to open the GUI, make sure you have installed xquartz on MAC and Xming or MobaXterm on windows are installed in your Laptop/Desktop.

Batch Mode
------------

1. Example job script to run a serial code:

.. code-block:: bash

    #!/bin/bash -l
    #SBATCH -N 1
    #SBATCH --ntasks-per-node=1
    #SBATCH --partition=batch
    #SBATCH -J test-matlab
    #SBATCH -o test-matlab.%J.out
    #SBATCH -e test-matlab.%J.err
    #SBATCH --time=00:20:00
    #SBATCH --mem=40G
    #SBATCH --constraint=[intel]
    #OpenMP settings:
    export OMP_NUM_THREADS=1
    module load matlab/R2023b
    cd /ibex/scratch/your_user_name/working_dir
    #run the application:
    matlab -nodisplay < your_file.m

2. Example job script to run a parallel code:

Prerequisite: Add the below lines at the beginning of .m file so the parallelism is done over the allocated cores.

.. code-block:: javascript

    pc = parcluster('local');
    parpool(pc, str2num(getenv('SLURM_CPUS_ON_NODE')));


Here is an example of a batch script to run a parallel MATLAB code running 40 workers on 40 cores.

.. code-block:: bash

    #!/bin/bash -l
    #SBATCH -N 1
    #SBATCH --ntasks-per-node=40
    #SBATCH --partition=batch
    #SBATCH -J test-matlab
    #SBATCH -o test-matlab.%J.out
    #SBATCH -e test-matlab.%J.err
    #SBATCH --time=00:20:00
    #SBATCH --mem=40G
    #SBATCH --constraint=[intel]
    #OpenMP settings:
    export OMP_NUM_THREADS=1
    module load matlab/R2023b
    cd /ibex/scratch/your_user_name/working_dir
    #run the application:
    matlab -nodisplay < your_file.m

Workaround when running multiple parpool jobs
----------------------------------------------

Sometimes when running multiple parpool jobs simultaneously, conflict between the jobs may happen.
i.e., Parpool needs a temporary location to store files for workers synchronization under:

.. code-block:: bash

     /home/$USER/.matlab

Solution:

In your batch file add this line before running the matlab line:

.. code-block:: bash

     mkdir –p $SCRATCH/$SLURM_JOB_ID

In the .m file add also the lines:

.. code-block:: bash

     pc = parcluster('local')
     pc.JobStorageLocation = strcat(getenv('SCRATCH'),'/', getenv('SLURM_JOB_ID'))
     parpool(pc, str2num(getenv('SLURM_CPUS_ON_NODE')))

Here is the MATLAB example:

.. code-block:: bash

     pc = parcluster('local')
     pc.JobStorageLocation = strcat(getenv('SCRATCH'),'/', getenv('SLURM_JOB_ID'))
     parpool(pc, str2num(getenv('SLURM_CPUS_ON_NODE')))
     tic
     ticBytes(gcp);
     n = 200;
     A = 500;
     a = zeros(1,n);
     parfor I = 1:n
     a(i) = max(abs(eig(round(A))));
     end
     tocBytes(gcp)
     toc















