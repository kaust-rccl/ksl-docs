Large Memory Jobs
===================

Normal compute nodes have memory up to ~ 360GB per node.

* large memory job is a label that’s assigned to your job by SLURM if you ask for memory => 370G

* Use ``--mem=####G`` to request nodes with large memory.

* When you don't specify ``--mem``, the default memory allocation will be 2GB
