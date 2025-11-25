.. sectionauthor:: Kadir Akbudak <kadir.akbudak@kaust.edu.sa>
.. meta::
    :description: gdb4hpc
    :keywords: debugging,gdb4hpc

.. _gdb4hpc:

*******
gdb4hpc
*******

gdb4hpc is used to debug parallel applications with multiple MPI ranks.
Please do not forget to add ``-g`` as a compile flag to get the source code line information.

The debugger can be run as follows:

.. code-block:: bash

    $ module load cpe/25.09
    $ module load gdb4hpc
    $ gdb4hpc
    dbg all> launch $a{8} --launcher-args="-N2" ./my_binary --args="arg1 arg2 arg3"
    Starting application, please wait...
    Launched application...
    8/8 ranks connected... (timeout in 300 seconds)
    8/8 ranks connected.
    Created network...
    Connected to application...
    Launch complete.
    a{0..7}: Initial breakpoint, main at /scratch/akbudak/iops/sw/hello.c:6
    dbg all> bt
    a{0..7}: #0  main at /scratch/akbudak/iops/sw/hello.c:6


Here, ``$a{8}`` means that 8 MPI tasks will launch. ``-N2`` means that these MPI tasks will run on two nodes.
    
.. toctree::
   :titlesonly:
   :maxdepth: 1
   :hidden:


