Ibex
----

.. _policies_storage:

For new users:
^^^^^^^^^^^^^^

``/home/{user}`` - this is your personal home directory and is limited to **200GB** of data. Do not run HPC jobs in your home directory - just use it for keeping configurations, scripts etc. 

``/ibex/user/{user}`` - this is your HPC storage. Use this storage for saving the output of, and input to compute jobs. This is much faster than your home directory so your jobs will run quicker. This directory has a limit of **1.5TB.** If you need more storage contact the Ibex support team. 

``/tmp`` - for job specific temporary files specify this directory. Once your job finishes all files in this directory will be deleted. Placing job temporary data in this directory will result in higher performance than storing it in your scratch area; won't contribute towards your used quota; and will automatically be deleted when your job finishes.


Job Scheduling Limitations!
^^^^^^^^^^^^^^^^^^^^^^^^^^^
* **batch** partition (by default).
* Fair share allocation.
* Maximum **14 days** (must specify your time limit).
* Maximum **2000 jobs** can be submitted at a time.
* No reservation available (and RCAC approval required for special projects).
* Job arrays don't have any limitations and considered as a single job.
* Maximum GPUs usable at a time is **24**.
* Maximum CPUs (Cores) usable at a time is **1300**.
* Maximum memory usable at a time is **16TB**.

.. note::
   Please note that to utilize Ibex with these specified limits, users must be associated with a **PI** in https://my.ibex.kaust.edu.sa/teams

|

Any user who does not have a PI will be restricted to following resources
      *  Max job time **2 days.**
      *  Max **20 CPUs.**
      *  Max memory **256 GB**
      *  Can use **1 GPU** (Either **gtx1080ti** or **rtx2080ti**)

Once user has a **PI**, he can use Ibex normally.
    