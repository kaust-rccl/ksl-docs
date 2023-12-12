.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Data science platform
    :keywords: pytorch, lightning, machine learning, deep learning, dask, rapids

==============================
Data Science platforms
==============================

- This is a directory tree for documenting all about developing data science workflows on KSL platforms
- a bespoke quickstart guide to work with datasceince workloads
- We will list the information about the meta modules and their contents. 
- We will list about the details on how to install software as self-service model using pacake managers like conda, spack, containers etc.
- Cray's Machine Learning development enviroment will also be discussed here
- Hyperparameter libraries will be disucssed here
- Example jobscript related to distributed frameworks
- A high level introduction to NGC container registry 
- parallel data processing tools and techniques will be discussed, e.g. dask and rapids on CPUs and GPUs
- Accelerating machine learning using multithreaded ScikitLearn 
    - porting ML from CPUs to GPUs
- Deep Learning on AMD Genoa CPUs -- for those workloads which don't qualify for GPUs or are developing models and modest sized datasets


.. toctree::
    :titlesonly:
    :maxdepth: 1

    quickstart
    ml_module_ibex
    jobscript_templates/index
    dist_mldl/index
    big_data_proc/index
    tools/index