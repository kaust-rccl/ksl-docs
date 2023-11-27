.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Dask
    :keywords: dask, dask_mpi, dask_array, xarray

.. _dask_on_shaheen3:

==========================================
Dask on Shaheen 3
==========================================

Dask is a library for parallel computing in Python. From a programmer’s point of view, it has two components:

#. Dynamic task scheduler to optimize computation as farm of tasks. Once tasks are formed Dask can pipeline them as a workflow engine/manager and schedule them on available resources

#. Data structure representations called collections which are conducive to larger than memory computation when dealing with Big Data. When working with these data structures, a Python developer trades in familiar territories as working with Numpy, Pandas or Python futures etc. These collections leverage from the task scheduler to run.

Dask on Shaheen 3
==================
