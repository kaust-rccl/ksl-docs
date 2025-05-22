.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Using conda with containers
    :keywords: container, conda

.. _using_conda_containers:

======================================
Using conda from singularity container
======================================

It is a convenient and highly productive (though not always most performant) to install software using conda environment. Containerizing conda runtime may also enable portability of the runtime along and still retaining productivity.

This is a guide for working with images containing software install with conda  environments and how to activate a particular conda environment as entrypoint when running with Singularity container platform on KSL systems.

Creating a Docker image from Dockerfile
---------------------------------------

First you need to build an image that uses a base image containing conda and mamba package managers (the later is a parallel implementation of conda).

For this the Dockerfile show below is to be built using docker build command on your local machine (workstation/laptop), where docker is installed. As an example the Dockerfile installs a Bioinformatics application in a new directory called /software :

.. code-block:: bash

    FROM krccl/miniforge:latest
    LABEL maintainer="Mohsin Ahmed Shaikh (mohsin.shaikh@kaust.edu.sa)"
    LABEL version="1.5.0"

    RUN mamba create -n jupyter -y -c conda-forge -c bioconda genomad==1.5.0 && \
        mamba clean --all --yes

    WORKDIR /workdir
    COPY entrypoint.sh /software/entrypoint.sh
    RUN chmod +x /software/entrypoint.sh
    ENTRYPOINT ["/software/entrypoint.sh"]

Where the entrypoint.sh first activates the target conda environment and then takes the arguments of the containers' commandline to run as subsequent command:

.. code-block:: bash

    #!/bin/bash
    #Initialize conda
    source /software/bin/activate genomad
    exec "$@"

To build the a docker image from this Dockerfile:

.. code-block:: bash

    docker build -t genomad .

The above command will look for a file called Dockerfile and will build a docker image in your local docker image registry on your local machine.

To push this image on DockerHub, you first run the container, commit and then push it to the target repository (starting with your docker username) in DockerHub registry of images.

.. code-block:: bash

    docker run --name myapp genomad 
    docker commit -m "A newly built image contianing genomad" mshaikh/genomad:1.5.0


Creating a modified Singularity Image File from Docker image
------------------------------------------------------------

On HPC systems of KSL, we use Singularity as our container platform to run containers. For this we  pull the image we worked with to bring it on Ibex.

Singularity understands Singularity Image Format and the singularity pull or singularity build command creates one from the docker image.

By default, Singularity disables any entrypoint behavior in docker images. To re-enable the entrypoint we will rebuild the genomad image into a SIF format using a Singularity definition file which describes what to change in the base docker image. Our singularity definition file genomad.def is pretty minimal. It activates the target conda environment and allows running any command passed on singularity command line: 

.. code-block:: bash

   Bootstrap: docker
   From: krccl/genomad:1.5.0

    %runscript 
        . /software/etc/profile.d/conda.sh
        conda activate genomad
        exec "$@"

In the genomad.def file shown above, we first pull our docker image from DockerHub. They add instructions to enable running a script upon creation of a container, which activates our conda environment. 

Building the SIF images is only possible on Ibex compute nodes. We therefore write a SLURM jobscript to submit the build process to run on a compute node using singularity fakeroot feature. fakeroot is required because the building of Singaularity images from Singularity definition files requires a temporary privilege escalation.

The jobscirpt looks as follows:

.. code-block:: bash

    #!/bin/bash

    #SBATCH -n 1 
    #SBATCH -t 00:10:00 

    module load singularity

    singularity build --fakeroot --force ./genomad.sif ./geomad.def

Note that this job can take longer than 10 minutes, depending on the size of the docker image. 

Upon successful completion of the SLURM job, you should end up with a genomad.sif file which is an executable.

Running a Container from the new Image
--------------------------------------

Now that we have a Singularity image for our application that was built with conda environment, we can create a container to run our commands. In the following, I am querying help on genomad application:

.. code-block:: bash

    module load singularity
    singularity run ./genomad.sif genomad -h

.. sourcecode:: 

    WARNING: underlay of /etc/localtime required more than 50 (88) bind mounts
                                                                                                                                                                            
    Usage: genomad [OPTIONS] COMMAND [ARGS]...                                                                                                                                 
                                                                                                                                                                                
    geNomad: Identification of mobile genetic elements                                                                                                                         
    Read the documentation at: https://portal.nersc.gov/genomad/                                                                                                               
                                                                                                                                                                                
    ╭─ Options ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │                                                                                                                                                                          │
    │  --version        Show the version and exit.                                                                                                                             │
    │  --help      -h   Show this message and exit.                                                                                                                            │
    │                                                                                                                                                                          │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
    ╭─ Database download ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │                                                                                                                                                                          │
    │   download-database            Download the latest version of geNomad's database and save it in the DESTINATION directory.                                               │
    │                                                                                                                                                                          │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
    ╭─ End-to-end execution ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │                                                                                                                                                                          │
    │   end-to-end   Takes an INPUT file (FASTA format) and executes all modules of the geNomad pipeline for plasmid and virus identification. Output files are written in     │
    │                the OUTPUT directory. A local copy of geNomad's database (DATABASE directory), which can be downloaded with the download-database command, is required.   │
    │                The end-to-end command omits some options. If you want to have a more granular control over the execution parameters, please execute each module          │
    │                separately.                                                                                                                                               │
    │                                                                                                                                                                          │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
    ╭─ Modules ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
    │                                                                                                                                                                          │
    │   annotate                    Predict the genes in the INPUT file (FASTA format), annotate them using geNomad's markers (located in the DATABASE directory), and write   │
    │                               the results to the OUTPUT directory.                                                                                                       │
    │                                                                                                                                                                          │
    │   find-proviruses             Find integrated viruses within the sequences in INPUT file using the geNomad markers (located in the DATABASE directory) and write the     │
    │                               results to the OUTPUT directory. This command depends on the data generated by the annotate module.                                        │
    │                                                                                                                                                                          │
    │   marker-classification       Classify the sequences in the INPUT file (FASTA format) based on the presence of geNomad markers (located in the DATABASE directory) and   │
    │                               write the results to the OUTPUT directory. This command depends on the data generated by the annotate module.                              │
    │                                                                                                                                                                          │
    │   nn-classification           Classify the sequences in the INPUT file (FASTA format) using the geNomad neural network and write the results to the OUTPUT directory.    │
    │                                                                                                                                                                          │
    │   aggregated-classification   Aggregate the results of the marker-classification and nn-classification modules to classify the sequences in the INPUT file (FASTA        │
    │                               format) and write the results to the OUTPUT directory.                                                                                     │
    │                                                                                                                                                                          │
    │   score-calibration           Performs score calibration of the sequences in the INPUT file (FASTA format) using the batch correction method and write the results to    │
    │                               the OUTPUT directory. This module requires that at least one of the classification modules was executed previously                         │
    │                               (marker-classification, nn-classification, aggregated-classification).                                                                     │
    │                                                                                                                                                                          │
    │   summary                     Generates a classification report file for the sequences in the INPUT file (FASTA format) and write it to the OUTPUT directory. This       │
    │                               module requires that at least one of the base classification modules was executed previously (marker-classification, nn-classification).   │
    │                                                                                                                                                                          │
    ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

