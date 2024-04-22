.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: using Rstudio
    :keywords: Rstudio

.. _rstudio:


=============
R Studio
=============

RStudio Server is a client/server version of RStudio that runs on a remote server and is accessed via the client's web browser.

To use RStudio Server on IBEX , a user submits a SLURM job script. This allows RStudio Server to run on any available resources . A default job script that should suffice for most users is provided.

After a user is done using RStudio Server, they should save their work in RStudio, and then stop RStudio Server by cancelling the job with the slurm's ``scancel`` command

Building Rstudio image
------------------------

You can pull a prebuilt version of the singularity image from singularity repo by using the command​s:

.. code-block:: bash

    module load singularity/3.9.7
    singularity pull library://mgharawy97/collection/rstudio-server.sif


However, if you want to customize your own version of the image, you can modify the following singularity definition file and build your own version.

.. note::

    The following commands assume this file is named rstudio.def

.. code-block:: bash

    Bootstrap: docker
    From: rockylinux:9.3

    %labels
            Author Apps-Team
            Version v0.0.1

    %help
            This container Provides R-Studio on Rocky-Linux 9.3 with the capability of loading ibex modules.

    %post
        dnf update -y && \
        dnf install -y dnf-plugins-core \
        epel-release

        dnf update -y && \
        dnf install -y \
            make \
            automake \
            gcc \
            gcc-c++ \
            kernel-devel \
            git \
            hdf5-devel.x86_64 \
            libcurl-devel \
            openssl-devel \
            libpng-devel \
            boost-devel \
            libxml2-devel \
            java-1.8.0-openjdk-devel \
            python3-devel \
            python3-pip \
            wget \
            fftw-devel \
            gsl-devel \
            glpk \
            glpk-devel \
            which \
            tcl \
            tcl-devel \
            procps \
            ed \
            less \
            vim-minimal \
            wget \
            ca-certificates \
            openblas.x86_64 \
            glibc-langpack-en \
            chkconfig \
            initscripts \
            libselinux-utils \
            texlive-collection-fontsrecommended \
            https://rpmfind.net/linux/centos/8-stream/AppStream/x86_64/os/Packages/compat-openssl10-1.0.2o-4.el8.x86_64.rpm

        # Install igraph
        pip install python-igraph

        # Install R
        dnf update -y && \
        dnf install --enablerepo=crb -y \
            R-littler \
            R \
            R-devel \
            R-core \
            R-core-devel && \
        ln -s /usr/lib64/R/library/littler/examples/install.r /usr/local/bin/install.r && \
        ln -s /usr/lib64/R/library/littler/examples/install2.r /usr/local/bin/install2.r && \
        ln -s /usr/lib64/R/library/littler/examples/installBioc.r /usr/local/bin/installBioc.r && \
        ln -s /usr/lib64/R/library/littler/examples/installDeps.r /usr/local/bin/installDeps.r && \
        ln -s /usr/lib64/R/library/littler/examples/installGithub.r /usr/local/bin/installGithub.r && \
        ln -s /usr/lib64/R/library/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r && \

        # Clean up
        rm -rf /tmp/downloaded_packages/ /tmp/*.rds
        #ln -s /usr/lib64/libopenblaso.so.0 /usr/lib64/libopenblas.so.0

        # Build Environment Module from source code
        wget https://sourceforge.net/projects/modules/files/Modules/modules-5.3.1/modules-5.3.1.tar.gz
        tar -zxvf modules-5.3.1.tar.gz
        cd modules-5.3.1
        ./configure --with-modulepath=/usr/local/Modules/contents
        make && make install
        # Directories Configuration
        mkdir /sw
        mkdir /ibex
        mkdir -p /ibex/sw
        mkdir -p /ibex/user
        ln -s /usr/local/Modules/bin/modulecmd /usr/bin/modulecmd
        mkdir -p /etc/init.d/

        # Install RStudio
        dnf install -y https://download2.rstudio.org/server/rhel9/x86_64/rstudio-server-rhel-2023.12.1-402-x86_64.rpm

    %environment
        export LC_ALL=en_US.UTF-8
        export LANG=en_US.UTF-8
        export MODULEPATH=/etc/scl/modulefiles:/sw/rl9c/modulefiles/applications:/sw/rl9c/modulefiles/compilers:/sw/rl9c/modulefiles/libs:/sw/services/modulefiles:/usr/share/Modules/modulefiles:/etc/modulefiles:/usr/share/modulefiles:/sw/services/modulefiles:/sw/services_rl9/modulefiles

    %startscript
        # Disable SELinux
        setenforce 0
        # Stop Rstudio-server service
        exec rstudio-server stop


You can build an image from this definition file using the commands:

.. note::

    You can only build singularity images on a compute node, please either reserve an interactive session through srun or salloc commands or run them from a jobscript using the sbatch command.

.. code-block:: bash

    module load singularity/3.9.7
        singularity build --fakeroot rstudio-server.sif_latest.sif rstudio.def


Starting with Rstudio
------------------------

Submit the RStudio SLURM job script, for example, the following is a jobscript requesting CPU resources on Ibex. Say our jobscript's name is rstudio.sh:

.. note::

    To use the libraries you have installed in your home from one of the R modules on Ibex inside the container:
        - uncomment the R_LIBS variable and edit the value to match the libraries install path (can be found by loading the R module and using ``echo $R_LIBS``).
        - add the same R module used to install the librarires to the variable modules. 


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

    module load singularity/3.9.7

    # Pull singularity image
    singularity pull library://mgharawy97/collection/rstudio-server.sif
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
    #export R_LIBS=/home/$USER/local/R4.3.0_libs.gnu
    exec rsession "\${@}"
    END

    chmod +x ${workdir}/rsession.sh

    export SINGULARITY_BIND="${workdir}/run:/run,${workdir}/tmp:/tmp,${workdir}/database.conf:/etc/rstudio/database.conf,${workdir}/rsession.sh:/etc/rstudio/rsession.sh,${workdir}/var/lib/rstudio-server:/var/lib/rstudio-server,/sw:/sw,/ibex/sw:/ibex/sw:/ibex/user:/ibex/user"

    # Do not suspend idle sessions.
    # Alternative to setting session-timeout-minutes=0 in /etc/rstudio/rsession.conf
    # https://github.com/rstudio/rstudio/blob/v1.4.1106/src/cpp/server/ServerSessionManager.cpp#L126
    export SINGULARITYENV_RSTUDIO_SESSION_TIMEOUT=0

    export SINGULARITYENV_USER=$(id -un)
    # get unused socket per https://unix.stackexchange.com/a/132524
    # tiny race condition between the python & singularity commands
    readonly PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    cat 1>&2 <<END
    1. SSH tunnel from your workstation using the following command:

    ssh  -L ${PORT}:${HOSTNAME}:${PORT} ${SINGULARITYENV_USER}@ilogin.ibex.kaust.edu.sa

    and point your web browser to http://localhost:${PORT}

    When done using RStudio Server, terminate the job by:

    1. Exit the RStudio Session ("power" button in the top right corner of the RStudio window)
    2. Issue the following command on the login node:

        scancel -f ${SLURM_JOB_ID}

    END

    export SINGULARITYENV_PATH=$PATH:/usr/lib/rstudio-server/bin

    # Modify the value of next line to load the modules to use with Rstudio.
    export modules="bioconductor/3.16/R-4.2.0"

    singularity exec rstudio-server.sif_latest.sif \
        bash -c "module load ${modules}  && rm -rf ~/.local/share/rstudio/ && rserver --www-port=${PORT} \
                --auth-none=1 \
                --auth-pam-helper-path=pam-helper \
                --auth-stay-signed-in-days=30 \
                --auth-timeout-minutes=0 \
                --server-user=$(whoami) \
                --server-daemonize=0 \
                --auth-minimum-user-id=0 \
                --rsession-path=/etc/rstudio/rsession.sh"

    printf 'rserver exited' 1>&2  

    

 
To submit the above jobscript to the scheduler:
``sbatch rstudio.sh``

Once the job starts, the slurm error file created in the directory you submitted the job from, will have the instructions on how to reverse connect.

The slurm error will look something like this:

.. code-block:: bash
    :caption: The slurm error will look something like this

     1. SSH tunnel from your workstation using the following command:

     ssh  -L 44672:cn506-02-r:44672 $USER@ilogin.ibex.kaust.edu.sa

     and point your web browser to http://localhost:44672

     2. log in to RStudio Server using the following credentials:

     When done using RStudio Server, terminate the job by:

     1. Exit the RStudio Session ("power" button in the top right corner of the RStudio window)
     2. Issue the following command on the login node:

      scancel -f 17848677

Open a new terminal on your local machine and copy paste the ssh tunnel command

``ssh  -L 44672:cn506-02-r:44672 $USER@ilogin.ibex.kaust.edu.sa``

log in Rstudio server  via  web browser with given link and credentials in error file

.. code-block:: bash

    http://localhost:44672

