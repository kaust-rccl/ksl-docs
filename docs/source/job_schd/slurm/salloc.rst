salloc
=======

``salloc`` command to request allocation of resource for interactive use.
Primarily used for prototyping or debugging a workflow

.. code-block:: bash
    :caption:  A simple example  for using salloc:

    [selimrm@login510-27 ]$ salloc --gpus=1 --constraint=v100 -t 00:10:00
    salloc: Pending job allocation 27103111
    salloc: job 27103111 queued and waiting for resources
    salloc: job 27103111 has been allocated resources
    salloc: Granted job allocation 27103111
    salloc: Waiting for resource configuration
    salloc: Nodes gpu213-10 are ready for job
    [selimrm@login510-27 ]$ srun -n 1 hostname
     gpu213-10
     exit
    salloc: Relinquishing job allocation 27103111




