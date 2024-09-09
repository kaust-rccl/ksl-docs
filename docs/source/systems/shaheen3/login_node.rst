.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Available systems at KSL -- Login nodes
    :keywords: login node, compilation, module files
    
.. _shaheen3_login_node:

=============
Login Nodes
=============

Shaheen III has four login available for its users for software build and batch job submission using SLURM. Each of these login nodes is a dual sockets AMD EPYC 9534 (Genoa family) with a total of 128 cores and 384 GB of DDR5 memory. The login nodes have the same microarchitecture as the compute nodes, therefore, cross compilation is not required. The login nodes are internet facing, connected to KAUST network, and mount the same /home filesystem as previously on Shaheen II and Ibex.