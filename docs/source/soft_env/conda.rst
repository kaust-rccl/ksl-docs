.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Self service environment
    :keywords: conda

.. _conda_intro:

This is a new line

====================================
Environments maintained by users
====================================

Introduction
------------

Conda is a versatile package and environment manager that can greatly simplify the management of software dependencies, making it an excellent choice for scientific computing and data analysis tasks on HPC systems.

You will learn how to set up and utilize Conda to manage your software environment, install packages, and create isolated environments within the unique context of an HPC cluster.

Understanding HPC Environments
-------------------------------

Before we dive into using Conda, it's important to understand the nature of High-Performance Computing environments.

HPC clusters consist of multiple interconnected compute nodes that work together to process complex tasks efficiently.

These clusters often have unique software and hardware configurations that can pose challenges when it comes to software management.

Conda's Flexibility and Advantages
-----------------------------------

Conda's ability to create isolated environments and manage software dependencies is particularly advantageous in an HPC context. By utilizing Conda, you can:

- Easily create and manage isolated Python environments for your projects, ensuring compatibility and reducing conflicts with system-wide software.
- Install and switch between different versions of software packages without affecting other users or projects on the HPC cluster.
- Share and reproduce your software environment, enabling collaborators to quickly set up the same environment on their own machines.
- Leverage Conda's extensive package repository to access a wide range of pre-built scientific and data analysis tools.

.. toctree::
   :maxdepth: 1
   :titlesonly:

   using_conda