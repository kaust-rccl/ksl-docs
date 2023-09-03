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

Distributed Copy
^^^^^^^^^^^^^^^^
``dcp`` or distributed copy is a MPI-based copy tool developed by Lawrance Livermore National Lab (LLNL) as part of their ``mpifileutils`` suite. We have installed it on Shaheen. Here is an example jobscript to launch a data moving job with ``dcp``:

.. toctree::
   :maxdepth: 1
   :titlesonly:
   
   distributed_copy
   scp_rsync