.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Software environment 
    :keywords: programming, compilers, job scheduler, SLURM, containers, conda, modules

.. _software_env:


=====================
Software ecosystem
=====================

An ecosystem of optimized software applications and libraries is an essential ingredient for making the most of the HPC grade hardware available on :ref:`KSL systems <available_systems>`. 
KSL applications team is committed to providing compilers, scientific libraries and optimized applications to its our users, and they are upgraded from time to time. 
Additionally, for the user requiring frequent change in software or legacy software version, training, documentation and support is provided for them to maintain the required libraries and applications in their own space using some popular package managers. 

This page provides an entry point for exploring the software environment on provided different KSL systems, along with instructions on how to run different workloads, pre/postprocess, debug or profile their performance.
 
:ref:`science_platforms` is a great entry point for guidelines specific to science domains. 
The topics included range from opinionated quickstart to expert advice on how to best run specific applications, workloads and usecases on different KSL platforms.
  
.. toctree::
   :titlesonly:
   :maxdepth: 1

   prog_env/index
   job_schd/index
   prof_debug/index
   science_platforms/index
   visualization/index