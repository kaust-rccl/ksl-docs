Creating Singularity Containers
===============================

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

This definition file instructs Singularity to use a base Ubuntu image, update its package list, and install Python 3 inside the container.

Installing Software and Dependencies Inside a Singularity Container
-------------------------------------------------------------------

Singularity allows you to install software and dependencies just like you would on a regular system. Use the ``%post`` section in the definition file to execute commands during the container creation process. This ensures that the required software is present inside the container.

Defining Environment Variables and Configuring the Runtime Environment
----------------------------------------------------------------------

You can define environment variables within the container to customize its behavior. For example, you can set paths, specify default options, or configure application-specific settings. These environment variables are isolated within the container and do not affect the host system.

Building Containers from Scratch or Using Existing Base Images
--------------------------------------------------------------

You have the flexibility to build Singularity containers from scratch or use existing base images as a starting point. Creating a container from scratch allows complete customization, while using base images can save time by providing a pre-configured environment. The choice depends on your specific needs and the complexity of the application.

Using Container Recipes and Scripts to Automate Container Creation
------------------------------------------------------------------

For more complex containers, using container recipes and shell scripts can streamline the container creation process. Recipes define the sequence of commands to execute during container creation. These recipes can be versioned and shared, enabling collaboration and reproducibility.

Automation can also be achieved through shell scripts that encapsulate the container-building steps. These scripts simplify the process and ensure consistent container creation across different environments.

By mastering the creation of Singularity containers using definition files, you can tailor environments to your specific needs, package dependencies efficiently, and foster reproducibility in your HPC workflows.