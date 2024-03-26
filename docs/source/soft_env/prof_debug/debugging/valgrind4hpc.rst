.. sectionauthor:: Kadir Akbudak <kadir.akbudak@kaust.edu.sa>
.. meta::
    :description: valgrind4hpc
    :keywords: debugging,valgrind4hpc,memory,leak

.. _valgrind4hpc:

************
valgrind4hpc
************

valgrind4hpc is used to find memory related issues in parallel applications with multiple MPI ranks.

The tool can be run as follows:

.. code-block:: bash

    $ module load valgrind4hpc
    $ valgrind4hpc --valgrind-args="--vgdb=no" -n8 --launcher-args="-N2" --outputfile=vout.txt <binary>

The output of valgrind4hpc will be stored in ``vout.txt``. Errors for ranks are shown for collectively or separately depending on which ranks cause those errors:

.. code-block:: bash

	RANKS: <0,2,4,6>

	Conditional jump or move depends on uninitialised value(s)
	  at MPIC_Waitall (in ./oob)
	  by MPIR_CRAY_Bcast_Tree (in ./oob)
	  by MPIR_CRAY_Bcast (in ./oob)
	  by MPIR_Bcast_impl (in ./oob)
	  by PMPI_Bcast (in ./oob)
	  by darshan_core_shutdown (in ./oob)
	  by PMPI_Finalize (in ./oob)
	  by main (in oob.c:35)


	RANKS: <0..7>

	HEAP SUMMARY:
	  in use at exit: 32 bytes in 1 blocks

	LEAK SUMMARY:
	   definitely lost: 32 bytes in 1 blocks
	   indirectly lost: 0 bytes in 0 blocks
		 possibly lost: 0 bytes in 0 blocks
	   still reachable: 0 bytes in 0 blocks

	ERROR SUMMARY: 6 errors from 103 contexts (suppressed 170)

.. toctree::
   :titlesonly:
   :maxdepth: 1
   :hidden:


