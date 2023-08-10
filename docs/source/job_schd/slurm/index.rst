.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: SLURM Documentation
    :keywords: SLURM
    

==============================
SLURM
==============================

Resource sharing on a supercomputer dedicated to technical and/or scientific computing is often organized by a piece of software called a resource manager or job scheduler.
Users submit jobs, which are scheduled and allocated resources (CPU time, memory, etc.) by the resource manager.


Slurm is a resource manager and job scheduler designed to do just that, and much more. 
It was originally created at the Livermore Computing Center, and has grown into a full-fledge open-source software backed up by a large community, commercially supported by the original developers, and installed in many of the Top500 supercomputers.

SLURM manages more work than the available computational resources by scheduling queues of work.
It provides users with:

* ways to describe and submit a resource request as a "job"
* ways to prescribe how the workload will run once the requested resources are allocated
* ways to monitor the state of the submitted job
* ways to account for the usage of the resources (a charging system)  

Documented below are commands, example scripts and workflow patterns, users must be aware of when requesting computational resources on different KSL platforms.    

.. toctree::
   :titlesonly:
   :maxdepth: 1

   commands
   examples
   complex_workflows
   interactive_jobs
   


