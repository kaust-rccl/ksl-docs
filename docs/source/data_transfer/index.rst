.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Data transfer utilities and resources on KSL systems
    :keywords: scp, dcp, globus, rsync, data-movers, podman

==============================
Data Transfer 
==============================
Motivation
^^^^^^^^^^
Sometimes it is needed to copy large number of files from ``/scratch`` to ``/project`` or vice versa. Both ``cp`` and ``rsync`` are convenient but sometimes you need speed to do such task.

.. toctree::
   :titlesonly:
   :maxdepth: 1

   distributed_copy
   scp_rsync
