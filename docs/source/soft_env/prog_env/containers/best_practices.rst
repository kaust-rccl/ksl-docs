.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Containers best practices on Ibex
    :keywords: container, optimization

.. _singularity_best_practices:

=====================================
Best Practices for Singularity in HPC
=====================================

Optimizing Container Performance
--------------------------------

To maximize the benefits of Singularity in HPC, consider these optimization strategies:

- **Minimize Layers**: Reduce the number of layers in your container to minimize filesystem overhead.

- **Optimize Libraries**: Use system libraries whenever possible instead of including them in the container.

- **Compile for the Target System**: Libc version shouldn't be too old inside the container compared to host kernel.

.. note::

  .. code-block:: bash

      #You can check the kernel version by running:
      uname -r

Ensuring Security and Isolation Within Singularity Containers
-------------------------------------------------------------

Security is paramount in HPC environments. To ensure secure container usage:

- **Use Trusted Sources**: Obtain base images from trusted sources and verify their authenticity.

- **Limit Privileges**: Run containers with minimal privileges to prevent unauthorized access to sensitive resources.

- **Sandboxing**: Utilize Singularity's ability to enforce isolation by limiting container access to specific directories.

- **Singularity is Read Only by default**: Except for the directories mounted by default on Shaheen/Ibex /tmp, /home, /project (on Shaheen), /scratch

  Make it writable as sandbox if needed.

Efficient Management of Container Images
----------------------------------------

Effectively managing container images on HPC clusters is crucial for maintaining a well-organized environment:

- **Centralized Repositories**: Establish centralized repositories for storing and distributing container images.

- **Versioning**: Use version tags and maintain a consistent naming convention for images to facilitate tracking and updates.

- **Image Cleanup**: Regularly clean up unused or outdated container images to free up storage space.

  For large images, pull may fail due to insufficient space in /tmp
  Run singularity pull command in user directory.
  export SINGULARITY_TMPDIR=/ibex/user/$USER/some/path

- **cache management**: By default Docker image blobs are cached in ~/.singularity/cache
  
  It can fill pretty quickly you pull different images frequently.

  Move the cache directory to your user directory.
  export SINGULARITY_CACHEDIR=/ibex/user/$USER/cachedir
  
.. note::

  .. code-block:: bash

      #To check status of cache run:
      singularity cache list

      #To clean cache run:
      singularity cache clean

Scaling Containers
------------------

For large-scale computing environments, consider the following practices:

- **Parallelism**: Design containerized applications to leverage parallel processing for optimal resource utilization.

- **Distributed Filesystems**: Utilize distributed filesystems for data sharing and synchronization across nodes.

By following these best practices, you can unlock the full potential of Singularity in HPC environments, optimize performance, enhance security, and tackle challenges effectively.