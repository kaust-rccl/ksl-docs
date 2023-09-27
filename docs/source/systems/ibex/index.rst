.. _ibex_arch:

==========
Ibex
==========

Ibex is a HPC cluster at KSL. It is highly heterogeneous, which means that it has CPU and GPU nodes with various different microarchitectures.
Ibex cluster is for KAUST users only. External (non-KAUST) users are not able to access this system unless approved by the Research Computing Allocations Committee, an approving body for all the allocation on KSL systems.

Ibex cluster uses SLURM as job scheduler. You can learn more about SLURM and how to launch various kinds of job on Ibex in :ref:`job_scheduling` section.
Ibex nodes are multi-tenanted when allocated, which means a user's job will be sharing the compute resources on a specific compute node with other users. 
The isolation of workloads within a compute node is ensured by the SLURM. This implies that all the requested resource in a SLURM jobscript will reserved by the scheduler and will be utilized only by that user's workload. This also implies that a crashed job can safely exit without disrupting other users' workload.

Allowing compute nodes to be shared among users makes Ibex cluster more available for jobs requesting modest computational resources. Additionally, Ibex cluster caters longer wall times, maximum being 14 days.  
Although this appears to be an attractive feature of the system for some workloads, a lot of workloads can achieve much more in shorter wall time if the users worked with KSL support staff to optimize their workloads and workflows. Some examples of modifications include:
* optmizing use of requested resources
* enabling the code to user multiple CPUs or GPUs on multiple nodes
* optimizing file I/O for I/O bound codes etc


The topics listed below describe the architectural details of various components/sub-systems of Ibex cluster. 


.. toctree::
   :maxdepth: 1
   :titlesonly:
   :hidden:
   
   login_node
   compute_node
   interconnect
   filesystem
   
   



