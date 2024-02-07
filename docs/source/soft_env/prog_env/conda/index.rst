.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Self service environment
    :keywords: conda

.. _conda_intro:

====================================
Conda package manager
====================================


``conda`` is a versatile package and environment manager that can greatly simplify the management of software dependencies, making it an excellent choice for scientific computing and data analysis tasks on HPC systems.

You will learn how to set up and utilize ``conda`` to manage your software environment, install packages, and create isolated environments within the unique context of an HPC cluster.

Using ``conda`` becomes justified when user is looking either or all of the attributes below in their development environments:

- Easily create and manage isolated Python environments for your projects, ensuring compatibility and reducing conflicts with system-wide software.
- Install and switch between different versions of software packages without affecting other users or projects on the HPC cluster.
- Share and reproduce your software environment, enabling collaborators to quickly set up the same environment on their own machines.
- Leverage ``conda``'s extensive package repository to access a wide range of pre-built scientific and data analysis tools.

As a downside, it is possible to experience regression in performance compared to source built software, tunned for the target compute infrastructure. In most cases running either at small scale or which requires throughput, this tradeoff is justified. However, one may leave a significant performance on table specially when running at large scale. KSL's advice is to benchmark your production codes properly before consuming large amount of core hours. Lack of such information can adversely affect the outcomes of future allocation applications, specially in case of Shaheen 3.


.. toctree::
    :titlesonly:
    :maxdepth: 1

    shaheen3
    ibex