.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Memory hierarchy on CPUs
    :keywords: cache, L1, L2, L3, Last level cache
    
.. _memory_hierarchy_cpu_tech_article:

=======================================================================
Memory hierarchy on CPUs 
=======================================================================


The L3 or *Last Level Cache* is coherent across all the nodes which implies that if a `core` changes a memory location in L3, it will be visible to all cores. 
This does not apply to L1 and L2 caches which are local to each core. 