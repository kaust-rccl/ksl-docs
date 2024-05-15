.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: MS DeepSpeed
    :keywords: deepspeed

.. _deepspeed:

================================================
Microsoft DeepSpeed
================================================

Microsoft DeepSpeed is a library to enable efficient distributed training, fine-tuning and inference on CPUs and GPUs in a high configurable manner. The library is enabled on KSL systems as a module or can be installed in a personal ```conda``` environment. This documentation shows how to install DeepSpeed and launch mutliGPU/multicore jobs on KSL systems. 

DeepSpeed on Shaheen III
==========================

.. note::
    section under construction

DeepSpeed on Ibex
==================
DeepSpeed integrates well with SLURM on Ibex. It can either be used by loading the managed software modules or in a ```conda``` environment managed by the users in their own directories. 

For a ```conda``` environment, you can activate one with Python, Pytorch with CUDA and MPI library installed, and then install DeepSpeed using ```pip``` package manager.

.. code-block:: bash
    
    pip install deepspeed

In case you don't have a ```conda``` package manager, please refer to :ref:`conda_ibex_`


Running DeepSpeed on single node with multiGPUs
-------------------------------------------------

