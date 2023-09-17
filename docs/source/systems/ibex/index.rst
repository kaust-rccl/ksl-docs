.. _ibex_arch:

==========
Ibex
==========

Ibex is a HPC cluster at KSL. It is highly heterogeneous, which means that it has CPU and GPU nodes with various different microarchitectures.
Ibex cluster is for KAUST users only. External (non-KAUST) users are not able to access this system unless approved by the Research Computing Allocations Committee, an approving body for all the allocation on KSL systems.

Ibex cluster user SLURM as job scheduler. You can learn more about SLURM and how to launch various kinds of job on Ibex in :ref:`job_scheduling` section.
Ibex nodes are multi-tenanted when allocated, which means a user's job will be sharing the compute resources on a specific compute node with other users. 
The isolation of workloads is ensured by the SLURM though. This means whatever the jobscript requests SLURM will reserve them and will allow to be utilized only by that user's workload. 


The topics listed below describe the architectural details of various components/sub-systems of Ibex cluster. 


.. toctree::
   :maxdepth: 1
   :titlesonly:
   
   login_node
   compute_node
   interconnect
   filesystem
   
   



