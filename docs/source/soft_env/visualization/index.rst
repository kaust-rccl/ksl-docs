.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Visualization on KSL systems
    :keywords: ParaView, VisIt

.. _visualization:



=======================
Visualization
=======================

This section covers the basic use of Shaheen III for visualization and the supported software for running distributed visualization. 

.. note::
    KAUST Visualization Core Lab has many different videos on scientific visualization, see our `YouTube Channel <https://www.youtube.com/channel/UCR1RFwgvADo5CutK0LnZRrw>`_ for more info.

Supported Software
===================
KVL supports the use of ParaView and VisIt on KAUST computing resources. We facilitate the installation of new versions on both Ibex and Shaheen. Each of these softwares and their use of KSL resources are described in depth in their respective sections below. 

To find out the currently supported versions of ParaView and VisIt, simply use module avail:

.. code-block:: bash
    :caption: An example output of ``module avail`` on Shaheen III 
    
    xyz123@login1> module avail visit
    
    ------------------------------------------------------------- /sw/ex109genoa/modulefiles -------------------------------------------------------------
    visit/3.3.3


    xyz123@login1> module avail paraview

    ------------------------------------------------------------- /sw/ex109genoa/modulefiles -------------------------------------------------------------
    paraview/5.12.0-egl           paraview/5.12.0-mesa(default)

.. note::
    To learn more about how to use ParaView or VisIt both interactively and through batch scripting, see the documentation below. 



Visualization Resources
========================
.. toctree::
   :titlesonly:
   :maxdepth: 1
   
   bestpractices_visualization
   paraview_overview
   visit_overview
   insitu_overview
