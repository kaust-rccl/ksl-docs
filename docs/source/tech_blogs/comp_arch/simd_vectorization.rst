.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: SIMD vectorization
    :keywords: vectorization, avx, fma, 
    
.. _vectorization_cpu_tech_article:

==========================================
Understanding SIMD Vectorization
==========================================

SIMD (Single Instruction Multiple Data) Vectorization is an operand which takes multiple bytes and runs a single instruction on it. This is a hardware unit which can be targeted by either allowing the compilers to identify candidate data structures for SIMD vectorization or a programmer can explicitly expresses them in their program.