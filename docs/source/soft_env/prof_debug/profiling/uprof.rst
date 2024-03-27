.. sectionauthor:: Kadir Akbudak <kadir.akbudak@kaust.edu.sa>
.. meta::
    :description: AMD μProf 
    :keywords: profiling, cpu, shaheen3, AMD
.. _amd_μProf:

#########
AMD μProf
#########

AMD uProf is a performance analysis tool for applications. It allows developers to understand and improve the runtime performance of their application.

Roofline Performance Model
===========================

* The following steps demonstrate how to obtain a roofline performance model (https://dl.acm.org/doi/abs/10.1145/1498765.1498785) of your application on one node.

.. code-block:: bash

  salloc -N 1
  ssh nid0XXXX
  module load amduprof
  cd /scratch/$USER/iops/sw
  AMDuProfPcm roofline  -o ./roofline.csv ./a.out
  AMDuProfModelling.py -i ./roofline.csv -o . --memspeed 4800 -a MyHelloWorld --memory-roofs all

AMD uProf will generate the roofline figure in a PDF file.
  
