.. sectionauthor:: Didier Barradas Bautista <didier.barradasbautista@kaust.edu.sa>
.. meta::
    :description: Using podman to work with containers
    :keywords: container, podman

.. _using_podman_containers:

======================================
Overview
======================================

This guide details the steps for running Podman on a High-Performance Computing (HPC) environment. It specifically demonstrates launching a Docker image configured for Data Science and Tensorflow with support for NVIDIA GPUs. The guide will focus on a command involving various parameters and options to tailor the container environment for HPC needs.
---------------------------------------
To connect to the IBEX HPC system, you need to use SSH (Secure Shell), a protocol that provides encrypted communication sessions over unsecured networks. Here's how you can connect:

Open your Terminal and execute the SSH Command:
.. code-block:: bash
    ssh your_userusername@glogin.ibex.kaust.edu.sa

Once connected, you can request computational resources using SLURM commands. SLURM is a job scheduler that allocates resources, schedules, and manages jobs running on the HPC system.

.. note::
    ``podman`` is not present on the login nodes. Is is necessary to allocate for resources to use it 

Example SLURM Command for Resource Allocation
---------------------------------------

You can use the following command to start an interactive session with specific requirements:
.. code-block:: bash
    srun --gpus-per-node=1 --time=01:10:00 --nodes=1 --mem=200G --constraint=v100 --resv-ports=1 --pty bash -l

.. note::
    Explanation of the SLURM Command:
    - --gpus-per-node=1: Requests 1 GPUs per node.
    - --time=01:10:00: Sets the time limit for the session to 1 hour and 10 minutes.
    - --nodes=1: Requests one node.
    - --mem=200G: Requests 200 GB of memory.
    - --constraint=v100: Specifies the type of GPU, in this case, Nvidia V100.
    - --resv-ports=1: Requests reservation of one port, which can be useful for network communication needs.
    - --pty bash -l: Starts an interactive bash login shell.

Once the resources are allocated you have to create two spaces to work with ``podman`` with the following command : 

.. code-block:: bash
    mkdir -p /run/user/${UID}/bus /ibex/user/$USER/podman_images/

Before running the container with the desired settings, it's often beneficial to pre-download the Docker image to ensure that all required files are ready and to avoid delays during initialization. This can be particularly important in an HPC environment where network speed or availability might vary.

`Pulling the Docker Image Using Podman`
To pull the Docker image ahead of time, use the podman pull command. This command fetches the container image from a registry and stores it locally, allowing for quicker startup times when the image is run. Here is how you can do it:

.. code-block:: bash
    podman pull --root=/ibex/user/$USER/podman_images nginx

.. note::
    Explanation of the Pull Command:
    - podman pull: This is the command used to fetch the image from the Docker registry.
    - --root=/ibex/user/$username/podman_images: Specifies the root directory where the container images are stored. This is particularly useful for keeping all related data in a specific project directory, which helps in organizing and managing project files efficiently.
    - nginx: This is the name of the container image. The tf_gputag refers to the version of this image.

As we are still working on the terminal provided by the resource allocation

1. Execute the Pull Command as shown above. This command will download the image to the specified root directory.

2. Verify the Image: After the download is complete, you can verify the presence of the image by listing the images in ``podman``:

.. code-block:: bash
    podman images --root=/ibex/user/$USER/podman_images

This will show all images stored in the specified directory, including the newly pulled nginx.

.. note::
    Benefits of Pulling the Image Ahead of Time
    - Efficiency: Pulling the image beforehand can reduce the runtime preparation, as the image does not need to be downloaded during the podman run command execution.
    - Reliability: Having the image already downloaded can help avoid issues related to network connectivity or registry availability during the container start-up phase.
    - Management: Storing the images in a specific directory related to the project keeps the environment organized and makes it easier to manage different versions or types of images used for various projects.

By following these steps and using the podman pull command, you ensure that your containerized applications on HPC start smoothly and reliably, leveraging pre-downloaded images stored in an organized manner.


Example GPU enabled container and Jupyterlab
---------------------------------------
On this example we will download and run in the same command line a data science container that works with GPU.

.. code-block:: bash 
    podman --root=/ibex/user/$USER/podman_images pull abdelghafour1/tf_pip_gpu_vf:tf_gpu

Before running the command, it's crucial to understand its components and what each part does:

.. code-block:: bash
    podman run \
    -e NVIDIA_VISIBLE_DEVICES='' \
    --rm \
    -p 10000:8888 \
    -p 8501:8501 \
    -v ${PWD}:/app/mycode \
    --device=nvidia.com/gpu=all \
    --security-opt=label=disable \
    --root=/ibex/user/$username/podman_images \
    abdelghafour1/tf_pip_gpu_vf:latest \
    jupyter lab --ip=0.0.0.0 --allow-root 


.. note::
    Explanation of Parameters:
    -e NVIDIA_VISIBLE_DEVICES='': Clears the default setting of visible NVIDIA devices. This is often used to control GPU visibility for the container.
    
    Container Removal:
    --rm: Automatically removes the container when it exits. This helps in not accumulating stopped containers.
    
    Port Mapping:
    -p 10000:8888: Maps port 8888 inside the container to port 10000 on the host, used for Jupyter Lab access.
    -p 8501:8501: Maps port 8501 inside the container to port 8501 on the host, which could be used for other services like TensorBoard or Streamlit.
    
    Volume and Storage:
    -v ${PWD}:/app/mycode: Mounts the current working directory on the host to /app/mycode inside the container. This allows for sharing code files between the host and container.
    
    GPU and Security:
    --device=nvidia.com/gpu=all: Allocates all available NVIDIA GPUs to the container.
    --security-opt=label=disable: Disables SELinux security labeling within the container, which is necessary in some HPC setups for accessing shared resources.
    
    Root Directory:
    --root=/ibex/user/$username/podman_images: Specifies the root directory for storage of container data, allowing for persistent storage specific to the project.
    
    Container Image and Command:
    abdelghafour1/tf_pip_gpu_vf:latest: Specifies the Docker container image to use.
    
    jupyter lab --ip=0.0.0.0 --allow-root: Runs Jupyter Lab, accessible from any IP address and allows root access.


While Execute the command above. This will start the container and Jupyter Lab.

After running the command, Jupyter Lab will be accessible via a web browser at the URL shown in the output or at ``http://<your-ibex-hostname>.ibex.kaust.edu.sa:10000``.

Remember to replace <your-i-hostname> with the actual hostname of the node where the container is running.


Example of podman with SLURM 
---------------------------------------
You can also run podman in the background using tthe follwoing code. Lets assume you already pulled the image in the previous example.

.. code-block:: bash
    #!/bin/bash
    #SBATCH --time=01:00:00
    #SBATCH --nodes=1
    #SBATCH --gpus-per-node=1
    #SBATCH --cpus-per-gpu=16  
    #SBATCH --mem=32G
    #SBATCH --partition=batch 
    #SBATCH --job-name=jupyter
    #SBATCH --mail-type=ALL
    #SBATCH --output=%x-%j-slurm.out
    #SBATCH --error=%x-%j-slurm.err

    # setup the environment
    export XDG_RUNTIME_DIR=/tmp node=$(hostname -s) 
    user=$(whoami) 
    submit_host=${SLURM_SUBMIT_HOST} 
    port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    local_ip=$(hostname -I  | awk -F" " '{print $1}')

    echo -e " 

    ${node} pinned to port ${port} 

    You can now view your Jupyter Lab in your browser.

    Network URL: http://${local_ip}:${port}
    Network URL: http://${node}.kaust.edu.sa:${port}

    " >&2 

    mkdir -p /run/user/${UID}/bus /ibex/user/${user}/podman_images


    # launch podman

    podman run \
    -e NVIDIA_VISIBLE_DEVICES='' \
    --rm \
    -p ${port}:8888 \
    -p 8501:8501 \
    -v ${PWD}:/app/mycode \
    --device=nvidia.com/gpu=all \
    --security-opt=label=disable \
    --root=/ibex/user/${user}/podman_images \
    abdelghafour1/tf_pip_gpu_vf:tf_gpu \
    jupyter lab --ip=0.0.0.0 --allow-root 


Then take a look for the %x-%j-slurm.err file , inside you have to to copy the line in the top of the file  http://${local_ip}:${port} , and then at the botton look for the token in order to get access to jupyter lab.

Conclusion
---------------------------------------
Using Podman on IBEX for running advanced computational tools like Jupyter lab with TensorFlow in a containerized environment provides flexibility, scalability, and ease of management. This tutorial outlines the steps and details necessary to deploy such an environment efficiently and effectively.