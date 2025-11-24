.. sectionauthor:: Kadir Akbudak <kadir.akbudak@kaust.edu.sa>
.. meta::
    :description: ddt
    :keywords: debugging,linaro,ddt,debugger

.. _ddt:

***********
Linaro DDT
***********

`Linaro DDT <https://docs.linaroforge.com/25.1/html/forge/ddt/get_started_ddt/index.html>`_ is used to debug parallel applications with multiple MPI ranks.

.. note::
    Please do not forget to add ``-g`` as a flag during compilation of your source to get the line information in the debugger.

The debugger can be run as follows:

.. code-block:: bash

    $ ssh -XY shaheen.hpc.kaust.edu.sa
    $ module load arm-forge
    $ ddt

