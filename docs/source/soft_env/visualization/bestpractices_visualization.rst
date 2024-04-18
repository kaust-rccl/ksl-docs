.. sectionauthor:: James Kress <james.kress@kaust.edu.sa>
.. meta::
    :description: Visualization on KSL systems
    :keywords: ParaView, VisIt, Best_practices

.. _bestpractices_visualization:

==============================
Visualization Best Practices
==============================

#. If your data is small/manageable
    * Do your visualizations on your laptop or desktop

#. If your data is medium/large
    * Do interactive visualization on Ibex
        * Run ParaView or VisIt on your local machine and connect directly to Ibex to load/process/visualize
            * `Using ParaView Interactively <https://gitlab.kitware.com/jameskress/KAUST_Visualization_Vignettes/-/tree/master/ParaView_Vignettes?ref_type=heads#using-paraview-interactively-on-ibex>`_
            * `Using VisIt Interactively <https:=//gitlab.kitware.com/jameskress/KAUST_Visualization_Vignettes/-/tree/master/VisIt_Vignettes?ref_type=heads#using-visit-interactively-on-ibex>`_

#. If your data is large/huge and you have a defined workflow
    * Do batch visualization on Shaheen
        * `Batch Processing with ParaView <yhttps://gitlab.kitware.com/jameskress/KAUST_Visualization_Vignettes/-/tree/master/ParaView_Vignettes?ref_type=heads#expy>`_
        * `Batch Processing with VisIt <https://gitlab.kitware.com/jameskress/KAUST_Visualization_Vignettes/-/tree/master/VisIt_Vignettes?ref_type=heads#expy>`_

#. If you have repeatable repetitive tasks
    * Do scripted or batch visualization


Reach out
==========
Contact the KAUST Visualization Core Lab for visualization advice, help, collaboration, and consulting:

* `KVL Wiki <https://wiki.vis.kaust.edu.sa/>`_
* KVL email: help@vis.kaust.edu.sa
