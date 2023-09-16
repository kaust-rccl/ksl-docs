.. _ibex_login_nodes:

Login nodes
-----------
The login nodes provide an external interface to the Ibex computing cluster. They are for preparing submission scripts for the batch queue, submitting and monitoring jobs in the batch queue, analyzing results, and moving data. It is NOT appropriate for running computational jobs or compiling software. To do this use one of the compute nodes. If necessary, you can request an interactive session by following the guide in job scheduling. 
.. ref:`job scheduling <job_scheduling>`

Ibex clusters consist of 3 different login nodes:

.. code-block:: default
    :caption: ilogin(CPU)

    ssh -X username@ilogin.ibex.kaust.edu.sa

.. code-block:: default
    :caption: glogin(GPU)

    ssh -X username@glogin.ibex.kaust.edu.sa

.. code-block:: default
    :caption: vscode
    
    ssh -X username@vscode.ibex.kaust.edu.sa


**Table 1. Ibex login node Resources**
    
+----------------+-------------+---------+---------+---------+---------+----------------------+
|   CPU Family   |  CPU        |  NODES  |  CORES  |  CLOCK  |  FLOPS  |        MEMORY        |
+================+=============+=========+=========+=========+=========+======================+
|   Cascade Lake | cascadelake |    3    |   40    |   2.50  |   32    | 384 GB/usable 350 GB |
+----------------+-------------+---------+---------+---------+---------+----------------------+

.. note::

 To access the Ibex Clusters ,You only need to have kaust credentials(username & password).If you do not have kaust credentials yet or an external collaborator please contact the IT Help Desk at ithelpdesk@kaust.edu.sa to request an account. In case of external collaborator please make sure to request VPN access with destination "ibex-login" enabled.

**How to Login from Different Operating Systems?**

* For Mac OSx
 
  * Use your native terminal

         .. image:: MacOS.png

* Use your native terminal   

* For Windows
 
  * You need PuTTY or MobaXTerm or GitBash
  * Follow instructions on how to `login windows <https://www.youtube.com/watch?v=xfAydE_0iQo&list=PLaUmtPLggqqm4tFTwhCB48gUAhI5ei2cx&index=19>`_ 