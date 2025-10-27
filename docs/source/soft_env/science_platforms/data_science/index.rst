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

.. toctree::
    :titlesonly:
    :maxdepth: 1

    Getting started on Shaheen III <../../../quickstart/shaheen3>
    Getting started on Ibex <../../../quickstart/ibex>

Computational resources on KSL systems
=======================================

.. toctree::
    :titlesonly:
    :maxdepth: 1

    Shaheen III Login nodes <../../../systems/shaheen3/login_node>
    Shaheen III Compute nodes <../../../systems/shaheen3/compute_node>
    Ibex Login nodes <../../../systems/ibex/login_node>
    Ibex Compute nodes <../../../systems/ibex/compute_node>

Storage on KSL systems
========================

.. toctree::
    :titlesonly:
    :maxdepth: 1

    Shaheen III filesystems <../../../systems/shaheen3/filesystem>
    Ibex filesystems <../../../systems/ibex/filesystem>

Running Jobs on KSL systems
=======================================

.. toctree::
    :titlesonly:
    :maxdepth: 1

    SLURM jobscript explained <../../job_schd/basic_jobscript>
    Common SLURM commands <../../job_schd/slurm/commands>
    Running JupyterLab and VSCode <../../job_schd/slurm/interactive_jobs/index>
    Shaheen III example jobscripts <../../job_schd/slurm/shaheen3_jobscript_examples>
    Ibex example jobscripts <../../job_schd/slurm/ibex_jobscript_examples>



Software environment
=======================

.. toctree::
    :titlesonly:
    :maxdepth: 1
    
    KSL managed software on Ibex for Data Science <ml_module_ibex>
    Self-managed software <../../prog_env/index>
    Portable software in containers <../../prog_env/containers/index>
    

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
    Profiling GPU workloads with NVIDIA Nsight <../../prof_debug/profiling/nsight-systems/index>


Workflows
============

.. toctree::
    :titlesonly:
    :maxdepth: 1

    miscellaneous/ollama

