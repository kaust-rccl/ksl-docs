.. _ibex_login_nodes:

Login nodes
-----------

To access the Ibex Cluster , you need to have kaust credentials (username & password), same as you use for you KAUST email and KAUST portal.
If you do not have kaust credentials yet or an external collaborator please contact the :email:`IT Help Desk <ithelpdesk@kaust.edu.sa>` to request for an account. 
In case of external collaborator please make sure to request VPN access with destination "ibex-login" enabled.

The login nodes provide a way of interacting with computing resources and filesystems on Ibex cluster. Login nodes are a place where users can edit jobscripts, submit and monitor jobs in SLURM queues, analyze results, and move data between different directories and filesystems. It is **NOT** appropriate for running computational jobs.
Login nodes on Ibex have CPUs, therefore users should compile a GPU enabled software a compute node with a GPU. For CPU software, it is perimssible to compile on login nodes unless a code require 


.. _ibex_login_ssh:

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

.. _ibex_login_table1:
.. list-table:: **Ibex login nodes**
   :widths: 20 20 10 10 10 10 35
   :header-rows: 1

   * - CPU Family
     - CPU
     - Nodes
     - Cores/node
     - Clock (GHz)
     - FLOPS
     - Memory
   * - Intel CascadeLake
     - CascadeLake
     - 3
     - 40
     - 2.50
     - 32
     - 350GB 
   
Login to Ibex from workstation/laptop
--------------------------------------
You need an application call `ssh client` installed on your local machine in order to follow the steps to login any KSL system. 

Mac OSx
********

MacOS usually has a `terminal` application pre-installed. Please type Terminal in spotlight search tool to find it. 

         .. image:: MacOS.png
   
Open the `terminal`, copy and paste the :ref:`command <ibex_login_ssh>` for the appropriate login node you wish to access.  
  
Windows
******* 

To get a `ssh client` application on a Windows machine, you can opt from one of the following methods:

  * Download and install one of the `ssh` clients: PuTTY, MobaXTerm or GitBash
  * As an example, here is how to use `MobaXTerm on Windows <https://www.youtube.com/watch?v=xfAydE_0iQo&list=PLaUmtPLggqqm4tFTwhCB48gUAhI5ei2cx&index=19>`_ to access KSL systems 