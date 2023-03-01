.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Job schedulers on KSL systems
    :keywords: SLURM,kubernetes
    

==============================
Job Scheduling
==============================
Computational facilities of KSL are primarily used in batch mode. This implies that you submit a job with your resource request and the workload that you want to run and the scheduler will run it on your behalf when the resources are available.
This section documents what schedulers are and how users are expected to interact with it to run their jobs on compute nodes.
There is some common information that applies to all KSL systems but there are some differences which are detaled in sections corresponding to each system.  

This page contains details about basic information on job scheduling and querying/monitoring resources in general.
Also add details about the scheduler policy, job arrays, 

.. toctree::
   :titlesonly:
   :maxdepth: 1
   :hidden:

   slurm/index
   policy/index
   k8s/index