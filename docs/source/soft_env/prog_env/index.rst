.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Software environment of KSL systems
    :keywords: Software environment, Shaheen, Ibex

.. _prog_env:

===========================
Software environment
===========================

KSL systems come with a large list of applications installed by the HPC experts. 
There are ways users can explore and use these software to run their workloads.
Some users may want access to compilers, third-party libraries and tools to develope and optimize their source codes.
The installed applications are called managed software. Users can use modulefiles to access these applications.
For users developing, they are able to maintain their own software. 
They can either use the installed compiler suites and optimized libraries or use package manager such as ```pip```, ```conda```, ```spack``` or ```easybuild``` to install software environments in user space.
Another popular way of self-managing, rather bringing your own, software is to use containers.

This section helps navigate users to choose documentation depending on their needs.



This section introduces the software envrionments available on KSL systems. 

.. toctree::
   :titlesonly:
   :maxdepth: 1

   modulesystem/index
   python_package_management/index
   containers/index
   ../../apps_catalogue/index
   
