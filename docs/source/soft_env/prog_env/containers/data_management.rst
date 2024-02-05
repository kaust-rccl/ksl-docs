Using Bind Mounts and ACLs in Singularity
==========================================

Motivation
----------

Sometimes it's required to map directories on host to make them available inside a container or to control access to specific resources within Singularity containers.

Create a Singularity Definition File
-------------------------------------

Create a Singularity definition file (`.def`) with the following content to configure bind mounts and ACLs:

.. code-block:: bash

   Bootstrap: docker
   From: ubuntu:20.04

   %post
       # Install necessary software inside the container
       apt-get update && apt-get install -y software-package-1 software-package-2

       # Create a directory with restricted access
       mkdir /my_data

       # Set ACL to restrict access to the directory
       setfacl -m u:user1:rw /my_data
       setfacl -m u:user2:rw /my_data

   %runscript
       exec /path/to/your/application

Build the Singularity Container
-------------------------------

Build the Singularity container using the definition file:

.. code-block:: bash

   singularity build my_container.sif my_definition.def

Using Bind Mounts
-----------------

Now, you can run the container and specify the bind mount outside of the `.def` file using the `singularity run` or `singularity exec` command:

.. code-block:: bash

   # Bind mount the /host_data directory into /container_data while running the container
   singularity exec --bind /host_data:/container_data my_container.sif /path/to/your/application

.. note::

    If bind mounting directories, as on Shaheen, both PATH and 
    LD_LIRBARY_PATH needs to be updated.

    Bind mount $HOME can have some unintended implications:
    e.g. Python maintains user packages in $HOME
    To mitigate use --contain with singularity exec or run.

Using ACLs
----------

Inside the container, ACLs have been set on the `/my_data` directory to control access:

- ``setfacl -m u:user1:rw /my_data``: Grants read and write permissions to `user1`.
- ``setfacl -m u:user2:rw /my_data``: Grants read and write permissions to `user2`.

.. note::

   Please adapt the paths, commands, and ACL settings in the above instructions to your specific use case.

   For more information on Singularity, refer to the `Singularity documentation <https://sylabs.io/docs/>`_.
