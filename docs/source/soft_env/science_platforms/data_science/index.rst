.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Data science platform
    :keywords: pytorch, lightning, machine learning, deep learning, dask, rapids

.. _ds_platforms:

==============================
Data Science platform
==============================

Welcome to KSL's Data Science platform.
Here you will find the documentation on how to run Data Science and AI workloads on computational resources of KSL systems. The pages listed here walks you through from getting started on KSL systems, preparing your datasets, developing your models, and running the production jobs on multiple GPUs, and everything in between.
The aim of this documentation is not to teach you Data Science by to focus on how to leverage KSL computational resources to increase the productivity in your workflows.

Getting started
================

:ref:`Getting started on Shaheen III <quickstart_shaheen3>`

:ref:`Getting started on Ibex <quickstart_ibex_login>`

Computational resources on KSL systems
=======================================



:ref:`Shaheen III Login nodes <shaheen3_login_node>`

:ref:`Shaheen III Compute nodes <shaheen3_compute_nodes>`

:ref:`Ibex Login nodes <ibex_login_nodes>`

:ref:`Ibex Compute nodes <ibex_compute_nodes>`

Storage on KSL systems
========================


:ref:`Shaheen III filesystems <shaheen3_filesystem>`

:ref:`Ibex filesystems <ibex_filesystems>`

Running Jobs on KSL systems
=======================================


:ref:`SLURM job script explained <slurm_jobscript>`

:ref:`Common SLURM commands <slurm_commands>`

:ref:`Running JupyterLab and VSCode <interactive_jobs>`

:ref:`Shaheen III example job scripts <shaheen3_example_jobscripts>`

:ref:`Ibex example job scripts <ibex_jobs_examples>`



Software environment
=======================


.. toctree::
       :titlesonly:
       :maxdepth: 1

       KSL managed software on Ibex for Data Science <ml_module_ibex>

:ref:`Self-managed software <prog_env>`

:ref:`Portable software in containers <container_platforms_guide>`


Accelerating workloads
=======================


.. toctree::
       :titlesonly:
       :maxdepth: 1

       dist_mldl/index
       big_data_proc/index

Debugging and profiling
=========================


.. toctree::
       :titlesonly:
       :maxdepth: 1

       In-flight job telemetry with NVDashboard <tools/nvdashboard>

:ref:`Profiling GPU workloads with NVIDIA Nsight <nsight_profiling>`


Miscellaneous
=========================

.. toctree::
       :titlesonly:
       :maxdepth: 1

       ollama/index

