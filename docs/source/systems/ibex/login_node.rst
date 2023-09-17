.. _ibex_login_nodes:

Login nodes
-----------

To access the Ibex Cluster , you need to have kaust credentials (username & password), same as you use for you KAUST email and KAUST portal.
If you do not have kaust credentials yet or an external collaborator please contact the :email:`IT Help Desk <ithelpdesk@kaust.edu.sa>` to request for an account. 
In case of external collaborator please make sure to request VPN access with destination "ibex-login" enabled.

The login nodes provide a way of interacting with computing resources and filesystems on Ibex cluster. Login nodes are a place where users can edit jobscripts, submit and monitor jobs in SLURM queues, analyze results, and move data between different directories and filesystems. It is **NOT** appropriate for running computational jobs.
Login nodes on Ibex have CPUs, therefore users should compile a GPU enabled software a compute node with a GPU. For CPU software, it is perimssible to compile on login nodes unless a code require 



Ibex clusters consist of 3 different login nodes:

.. code-block:: default
    :caption: To submit CPU only jobs, login to `ilogin` 

    ssh -X username@ilogin.ibex.kaust.edu.sa

.. code-block:: default
    :caption: To submit jobs with GPU, login to `glogin`

    ssh -X username@glogin.ibex.kaust.edu.sa

.. code-block:: default
    :caption: If you want to access your files when editing/develop in IDE like `VS Code`, login to `vscode` 
    
    ssh -X username@vscode.ibex.kaust.edu.sa

.. note::
    Login to `vscode` login node does not mean give you the capabilty to debug your code. This is still a shared resource. Please run `code-server` as a job to debug your code on CPUs and GPUs. Please follow the :ref:`instruction on run VS Code jobs on compute nodes <vscode>`.   

**Table 1. Ibex login node Resources**
    
+----------------+-------------+---------+---------+---------+---------+----------------------+
|   CPU Family   |  CPU        |  NODES  |  CORES  |  CLOCK  |  FLOPS  |        MEMORY        |
+================+=============+=========+=========+=========+=========+======================+
|   Cascade Lake | cascadelake |    3    |   40    |   2.50  |   32    | 384 GB/usable 350 GB |
+----------------+-------------+---------+---------+---------+---------+----------------------+

.. list-table:: Ibex login nodes
   :widths: 20 20 10 10 10 10 35
   :header-rows: 1

   * - CPU Family
     - CPU
     - Nodes
     - Cores
     - Clock (MHz)
     - FLOPS
     - Memory
   * - Intel CascadeLake
     - CascadeLake
     - 3
     - 40
     - 2.50
     - 32
     - 350GB 
   
**How to Login from Different Operating Systems?**

* For Mac OSx
 
  * Use your native terminal

         .. image:: MacOS.png

* Use your native terminal   

* For Windows
 
  * You need PuTTY or MobaXTerm or GitBash
  * Follow instructions on how to `login windows <https://www.youtube.com/watch?v=xfAydE_0iQo&list=PLaUmtPLggqqm4tFTwhCB48gUAhI5ei2cx&index=19>`_ 