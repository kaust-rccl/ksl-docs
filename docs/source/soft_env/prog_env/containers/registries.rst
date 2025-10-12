.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Singularity registries
    :keywords: container, singularity, registry

.. _singularity_image_regestries:

=======================================
Using Image Registries with Singularity
=======================================

Contaienr platforms allow you to pull and use container images from various image registries,
providing a seamless way to access pre-built environments for your applications.
In this guide, we'll explore how to use image registries like Docker Hub and NVIDIA NGC.

Using Docker Hub Images with Singularity
----------------------------------------

`Docker Hub <https://hub.docker.com/>`_ is a popular image registry that hosts a vast collection of container images.
To use Docker Hub images with Singularity, you can follow these steps:

1. **Pulling Images**: Use the ``singularity pull`` command to download a Docker Hub image and convert it into a Singularity image file (SIF). For example:

   .. code-block:: bash

      singularity pull docker://ubuntu:latest

2. **Running Images**: Once the SIF is created, you can run applications within the container using the ``singularity exec`` command:

   .. code-block:: bash

      singularity exec ubuntu_latest.sif python3 my_script.py

Using NVIDIA NGC Images with Singularity
----------------------------------------

NVIDIA NGC is a registry specifically designed for GPU-accelerated workloads.
You can use NGC container images with Singularity for GPU-enabled applications.

Creating an account on NGC
--------------------------

1. Go to `GPU-optimized AI Software, Enterprise Services and Support <https://www.nvidia.com/en-us/gpu-cloud/>`_  and click on “Explore NGC Catalog”.

2. On the left top click on “Welcome Guest” and select “SignIn/SignOn”. This will take you to the following page where you select NVIDIA Account. If you have an existing NVIDIA developer account, use this otherwise create one:
image 1

3. Once signed in, click the drop down menu on left top with your profile and select Setup. This should take you to the following page. We have downloaded and installed the NGC CLI for you on Ibex as a module file. You can click on the Get API Key box and click “Generate API” on the subsequent page. Copy the API key you get.
image 2

4. Please load the module by logging on to glogin node and invoke the following command: 

.. code-block:: bash

      module load ngc
      ngc config set

Paste the copied API key. For the org choices, copy the org name adjacent to your profile name on the NGC Setup webpage as in Fig 2 and paste in your terminal. For all other prompts, simply press enter and select the default values.

.. code-block:: bash

      $ ngc config set
      Enter API key [no-apikey]. Choices: [<VALID_APIKEY>, 'no-apikey']: *****
      Enter CLI output format type [ascii]. Choices: [ascii, csv, json]: 
      Enter org [no-org]. Choices: ['******']: 
      Enter team [no-team]. Choices: ['no-team']: 
      Enter ace [no-ace]. Choices: ['no-ace']: 
      Successfully saved NGC configuration to /home/shaima0d/.ngc/config


Pulling an Image from NGC with Singularity
------------------------------------------

1. NGC container images are usually big in size. We prefer to pull these images on user directory which is WekaIO filesystem . First set the Singularity temporary and cache directories.

.. note::

      SINGULARITY_TMPDIR — specifies the temporary workspace for intermediate files during container builds or image operations.
      SINGULARITY_CACHEDIR — defines the persistent directory used to store and reuse downloaded image layers and metadata across sessions.

.. code-block:: bash
    
      export SINGULARITY_TMPDIR=/ibex/user/$USER/tmpdir
      export SINGULARITY_CACHEDIR=/ibex/user/$USER/cachedir

2. Similar to Docker Hub, use the ``singularity pull`` command to fetch NGC images and convert them to SIF format. For example:

   .. code-block:: bash

      singularity pull docker://nvcr.io/nvidia/pytorch:22.08-py3

2. **Running GPU Workloads**: Run GPU-accelerated workloads within the container using the ``--nv`` flag to enable GPU support:

   .. code-block:: bash

      singularity exec --nv pytorch_22.08-py3.sif python3 my_gpu_script.py
