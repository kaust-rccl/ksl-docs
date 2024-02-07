.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Creating singularity container
    :keywords: container, singularity, create

.. _create_singularity_images:

===============================
Creating Singularity Containers
===============================

Accesing Singularity
--------------------

Singularity is installed on Shaheen and Ibex.

.. code-block:: bash

    module load singularity

Singularity CLI
---------------

.. code-block:: bash

    singularity --help
    Options:
    -d, --debug print debugging information (highest verbosity)
    -h, --help help for singularity
    --nocolor print without color output (default False)
    -q, --quiet suppress normal output
    -s, --silent only print errors
    -v, --verbose print additional information
    --version version for singularity
    Available Commands:
    build Build a Singularity image
    cache Manage the local cache
    capability Manage Linux capabilities for users and groups
    config Manage various singularity configuration (root user only)
    delete Deletes requested image from the library
    exec Run a command within a container
    help Help about any command
    inspect Show metadata for an image
    instance Manage containers running as services
    key Manage OpenPGP keys
    oci Manage OCI containers
    plugin Manage Singularity plugins
    pull Pull an image from a URI
    push Upload image to the provided URI
    remote Manage singularity remote endpoints
    run Run the user-defined default command within a container
    run-help Show the user-defined help for an image
    search Search a Container Library for images
    shell Run a shell within a container
    sif siftool is a program for Singularity Image Format (SIF) file manipulation
    sign Attach a cryptographic signature to an image
    test Run the user-defined tests within a container
    verify Verify cryptographic signatures attached to an image
    version Show the version for Singularity

Basics of Creating Singularity Containers using Definition Files
----------------------------------------------------------------

Creating Singularity containers involves defining the container's content, environment, and dependencies using a *definition file*. A definition file is a simple text file that outlines the steps required to build the container. These steps can include installing software, setting environment variables, and configuring the runtime environment.

Here's a basic example of a Singularity definition file:

.. code-block:: bash

    Bootstrap: docker
    From: ubuntu:latest

    %post
        apt-get update
        apt-get install -y python3

This definition file (singularity_file.def) instructs Singularity to use a base Ubuntu image, update its package list, and install Python 3 inside the container.

Installing Software and Dependencies Inside a Singularity Container
-------------------------------------------------------------------

Singularity allows you to install software and dependencies just like you would on a regular system. Use the ``%post`` section in the definition file to execute commands during the container creation process. This ensures that the required software is present inside the container.

Defining Environment Variables and Configuring the Runtime Environment
----------------------------------------------------------------------

You can define environment variables within the container to customize its behavior. For example, you can set paths, specify default options, or configure application-specific settings. These environment variables are isolated within the container and do not affect the host system.

Build the container
-------------------

.. code-block:: bash

    singularity build --fakeroot singularity_file.def singularity_image.sif

The resulting singularity_file.sif can be run using commands like singularity run, singularity shell.

Ports are published by default, mapped on same ports as host.

While building images with --fakeroot on Ibex, Always allocate a compute node on, (won't work on login nodes).
export XDG_RUNTIME_DIR=$HOME/somewhere, to allow temporary space for Singularity to write intermediate blobs/images.

Building Containers from Scratch or Using Existing Base Images
--------------------------------------------------------------

You have the flexibility to build Singularity containers from scratch or use existing base images as a starting point. Creating a container from scratch allows complete customization, while using base images can save time by providing a pre-configured environment. The choice depends on your specific needs and the complexity of the application.

Using Container Recipes and Scripts to Automate Container Creation
------------------------------------------------------------------

For more complex containers, using container recipes and shell scripts can streamline the container creation process. Recipes define the sequence of commands to execute during container creation. These recipes can be versioned and shared, enabling collaboration and reproducibility.

Automation can also be achieved through shell scripts that encapsulate the container-building steps. These scripts simplify the process and ensure consistent container creation across different environments.

By mastering the creation of Singularity containers using definition files, you can tailor environments to your specific needs, package dependencies efficiently, and foster reproducibility in your HPC workflows.