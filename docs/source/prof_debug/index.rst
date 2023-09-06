.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Profiling and Debugging tools available on KSL systems
    :keywords: Profiling, Debugging, CrayPAT, DDT, map, perf-report, MICRO-prof, nsight

==============================
Profiling and Debugging tools
==============================
Deep learning workloads can be profiled to see how they use the GPU(s) and identify the hotspots of optimization. There are some tools that can be used for profiling, including:


    * nvprof is a command-line tool that is bundled with the CUDA toolkit. It can be used to profile GPU workloads and generate a report that shows the time spent in different functions and kernels.

    * Nsight Systems with NVTX instrumentation combines Nsight Systems and the NVTX profiling API. NVTX allows you to annotate your code with events, which Nsight Systems can track. This can help identify specific areas of your code that are causing performance problems.

This blog post will show how to use each tool to profile a deep learning workload. The example scripts mention are `here <https://github.com/D-Barradas/GPU_profiling_ibex>`_. You can check the src folder and find ``train.py`` , ``train-profiler.py`` , ``train_nvtx.py``

.. toctree::
   :maxdepth: 2

   using-nvprof
   nsight-systems
   
