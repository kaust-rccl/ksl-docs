.. sectionauthor:: Kadir Akbudak <kadir.akbudak@kaust.edu.sa>
.. meta::
    :description: Nsight-systems
    :keywords: nsight


###############
NSight Systems
###############

Deep learning workloads can be profiled to see how they use the GPU(s) and identify the hotspots of optimization. There are some tools that can be used for profiling, including:

    * Nsight Systems with NVTX instrumentation combines Nsight Systems and the NVTX profiling API. NVTX allows you to annotate your code with events, which Nsight Systems can track. This can help identify specific areas of your code that are causing performance problems.

This blog post will show how to profile a deep learning workload. The example scripts mention are `here <https://github.com/D-Barradas/GPU_profiling_ibex>`_. You can check the src folder and find ``train.py`` , ``train-profiler.py`` , ``train_nvtx.py``

.. toctree::
   :titlesonly:
   :maxdepth: 1

   nsight-quick-start
   nsight-nvtx
