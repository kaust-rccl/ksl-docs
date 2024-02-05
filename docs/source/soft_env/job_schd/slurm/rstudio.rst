R Studio
=============

RStudio Server is a client/server version of RStudio that runs on a remote server and is accessed via the client’s web browser

To use RStudio Server on IBEX , a user submits a SLURM job script. This allows RStudio Server to run on any available resources . A default job script that should suffice for most users is provided.

After a user is done using RStudio Server, they should save their work in RStudio, and then stop RStudio Server by cancelling the job with the slurm scancel command

Starting with Rstudio
------------------------

.. code-block:: bash
    :caption: Example for RStudio SLURM job script

     #!/bin/bash
     #SBATCH -N 1
     #SBATCH --time=01:00:00
     #SBATCH --ntasks=8
     #SBATCH --mem=50G
     #SBATCH --output=rstudio-server.job%j.out
     #SBATCH --error=rstudio-server.job%j.error

     # load singularity module

     module load singularity

     # Pull singularity image
     singularity pull docker://ranaselim8/rstudio-server:4.0.5
     ###################################


     # Create temporary directory to be populated with directories to bind-mount in the container
     # where writable file systems are necessary. Adjust path as appropriate for your computing environment.
     workdir=$(python -c 'import tempfile; print(tempfile.mkdtemp())')

     mkdir -p -m 700 ${workdir}/run ${workdir}/tmp ${workdir}/var/lib/rstudio-server
     cat > ${workdir}/database.conf <<END
     provider=sqlite
     directory=/var/lib/rstudio-server
     END

     # Set OMP_NUM_THREADS to prevent OpenBLAS (and any other OpenMP-enhanced
     # libraries used by R) from spawning more threads than the number of processors
     # allocated to the job.
     #
     # Set R_LIBS_USER to a path specific to rocker/rstudio to avoid conflicts with
     # personal libraries from any R installation in the host environment

     cat > ${workdir}/rsession.sh <<END
     #!/bin/bash
     export OMP_NUM_THREADS=${SLURM_JOB_CPUS_PER_NODE}
     export R_LIBS_USER=${HOME}/R/rocker-rstudio/4.0.5
     exec rsession "\${@}"
     END

     chmod +x ${workdir}/rsession.sh

     export SINGULARITY_BIND="${workdir}/run:/run,${workdir}/tmp:/tmp,${workdir}/database.conf:/etc/rstudio/database.conf,${workdir}/rsession.sh:/etc/rstudio/rsession.sh,${workdir}/var/lib/rstudio-server:/var/lib/rstudio-server"

     # Do not suspend idle sessions.
     # Alternative to setting session-timeout-minutes=0 in /etc/rstudio/rsession.conf
     # https://github.com/rstudio/rstudio/blob/v1.4.1106/src/cpp/server/ServerSessionManager.cpp#L126
     export SINGULARITYENV_RSTUDIO_SESSION_TIMEOUT=0

     export SINGULARITYENV_USER=$(id -un)
     export SINGULARITYENV_PASSWORD=$(openssl rand -base64 15)
     # get unused socket per https://unix.stackexchange.com/a/132524
     # tiny race condition between the python & singularity commands
     readonly PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
     cat 1>&2 <<END
     1. SSH tunnel from your workstation using the following command:

     ssh  -L ${PORT}:${HOSTNAME}:${PORT} ${SINGULARITYENV_USER}@ilogin.ibex.kaust.edu.sa

     and point your web browser to http://localhost:${PORT}

     2. log in to RStudio Server using the following credentials:

     user: ${SINGULARITYENV_USER}
     password: ${SINGULARITYENV_PASSWORD}

     When done using RStudio Server, terminate the job by:

     1. Exit the RStudio Session ("power" button in the top right corner of the RStudio window)
     2. Issue the following command on the login node:

     scancel -f ${SLURM_JOB_ID}
     END

     singularity exec --cleanenv rstudio-server_4.0.5.sif \
     rserver --www-port=${PORT} \
            --auth-none=0 \
            --auth-pam-helper-path=pam-helper \
            --auth-stay-signed-in-days=30 \
            --auth-timeout-minutes=0 \
            --rsession-path=/etc/rstudio/rsession.sh
     printf 'rserver exited' 1>&2  

 
To submit the above jobscript to the scheduler:
``sbatch rstudio.sh``

Once the job starts, the slurm error file created in the directory you submitted the job from, will have the instructions on how to reverse connect.

The slurm error will look something like this:

.. code-block:: bash
    :caption: The slurm error will look something like this

     1. SSH tunnel from your workstation using the following command:

     ssh  -L 44672:cn506-02-r:44672 selimrm@ilogin.ibex.kaust.edu.sa

     and point your web browser to http://localhost:44672

     2. log in to RStudio Server using the following credentials:

     user: selimrm
     password: z51lg7QpOZcI/gVNS/JX

     When done using RStudio Server, terminate the job by:

     1. Exit the RStudio Session ("power" button in the top right corner of the RStudio window)
     2. Issue the following command on the login node:

      scancel -f 17848677

Open a new terminal on your local machine and copy paste the ssh tunnel command

``ssh  -L 44672:cn506-02-r:44672 selimrm@ilogin.ibex.kaust.edu.sa``

log in Rstudio server  via  web browser with given link and credentials in error file

.. code-block:: bash

    http://localhost:44672
    user: selimrm
    password: z51lg7QpOZcI/gVNS/JX

NOTES
------

* RStudio Server is currently available Docker image (imported into Singularity) provided by the Rocker project

* RStudio Server is running in a container with a Debian base image, you won’t be able to access software environment modules

* By default, your home directory is mounted inside the RStudio Server container.

* RStudio to install additional R packages into your home directory inside the container.