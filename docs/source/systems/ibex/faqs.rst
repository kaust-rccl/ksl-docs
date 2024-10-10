.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Frequently asked questions for Ibex
    :keywords: Ibex, FAQs

.. _ibex_faqs:

============
FAQs
============

I am unable to access the clusters (Account Problems)
=====================================================

* I have used Dragon (now called Ibex) (or Shaheen, Noor, SMC,...) in the past OR I am a permanent (not-visiting) faculty, staff or student.
    To verify that there isn't a problem with your KAUST portal username and password, try to log into another KAUST system, for example KAUST Webmail or the KAUST Portal.
    
    If you can log into those systems, then Contact the Ibex sysadmins for help.

    If you are unable to log into any KAUST system, then wait 15 minutes and try again (to see if your account was temporarily locked out due to password failure) or contact the IT Helpdesk for assistance: ithelpdesk@kaust.edu.sa

* I am an external collaborator or visitor to KAUST.
    To create account for external user the PI or user sponsor must login to the KAUST Portal (portal.kaust.edu.sa) and select Self-Services. Under Self-Services find the tile named VPN access for External Users.

    Please fill all necessary entries and make sure to add the following message in field Host/IP/Services: Please add the user to ibex-login VPN group.

    Then submit the request.

    In case of any issues with VPN access or configuration please contact KAUST IT department at ithelpdesk@kaust.edu.sa (VPN is outside of Ibex jurisdiction).

Why are my resources limited and I can't use more than 1 gpu?
=============================================================

To use Ibex with standard resource limits, you must be associated with a PI.

To do this, please log in to https://my.ibex.kaust.edu.sa/teams and nominate a PI.

Once you do this, the nominated PI will receive an email notification to approve your request.

You can check your association with a PI by using the following command:

.. code-block:: bash
    :caption: Command to check PI
    
    whoismypi


Constraints and Features
=========================

Ibex makes heavy use of features and the contraints flags to direct jobs onto the appropriate resources. Combined with GRES this is a powerful and flexible way to allow a set of defaults which does the right thing for people who just want to run basic tasks and don't care about architecture, extra memory, accelerators, etc.

Below are some examples of how to request different resource configurations. The nodes are weighted such that the least valuable/rare node which can satisfy the request will be used. Be specific if you want a particular shaped resource.

* To see a list of full node features:

.. code-block:: bash
    :caption: Command to list all node features

    [hanksj@dbn-503-5-r:~]$ sinfo --partition=batch --format="%n %f"


* Specific CPU architecture:
    The Intel nodes perform much better for floating point operations while the AMD nodes are more efficient at integer operations. A common approach to optimizing your workload is to send integer or floating point work to the correct arch. Each node has a feature, either intel or amd, for it's arch. To select one:

    .. code-block:: bash
        :caption: Commands to select amd/intel node

        # Intel
        [hanksj@dm511-17:~]$ srun --pty --time=1:00 --constraint=intel bash -l
        [hanksj@dbn711-08-l:~]$ grep vendor /proc/cpuinfo | head -1
        vendor_id    : GenuineIntel
        [hanksj@dbn711-08-l:~]$ 

        # AMD
        [hanksj@dm511-17:~]$ srun --pty --time=1:00 --constraint=amd bash -l
        [hanksj@db809-12-5:~]$ grep vendor /proc/cpuinfo | head -1
        vendor_id    : AuthenticAMD
        [hanksj@db809-12-5:~]$ 

* Specific GPU or specific architecture:
    There are two basic ways to ask for GPUs.

    You want a specific count of a specific model of GPU:

    .. code-block:: bash
        :caption: Commands to select gpu type for node

        # Request 2 P100 GPUs.
        [hanksj@dm511-17:~]$ srun --pty --time=1:00 --gres=gpu:p100:2 bash -l
        [hanksj@dgpu703-01:~]$ nvidia-smi

    You want a specific count of any type of GPU:

    .. code-block:: bash
        :caption: Commands to select any gpu node

        # Request 1 GPU of any kind
        [hanksj@dm511-17:~]$ srun --pty --time=1:00 --gres=gpu:1 bash -l
        [hanksj@dgpu502-01-r:~]$ nvidia-smi

    If there are no nodes available; raise a ticket to the systems team to do a reservation for a specific node clarifying the reasons and scope of work.

How many types of nodes are available on the GPU cluster?
==========================================================
* A100

* V100

* P100

* P6000

* GTX 1080 Ti

* RTX 2080 Ti

Why should I set --time= in all jobs?
======================================

Setting a ``--time`` to the best estimate possible for your job accomplishes several important functions:

* Using the shortest time possible makes the job better suited to running as backfill, making it run sooner for you and increasing overall utilization of the resources.
* When a future reservation is blocking nodes for maintenance or other purposes, specifying the shortest time possible can allow more jobs to run to completion before the reservation becomes active.
* Forcing the inclusion of ``--time`` in all jobs reduces confusion resulting from job behavior under non-optimal default time limit settings.
* Learning to estimate how long your applications will run makes you a better and more well-rounded person.

Why do I get the following locale error?
=========================================

Setting locale failed.
Please check that your locale settings:

    LANGUAGE = (unset)

    LC_ALL = (unset)

    LC_CTYPE = "UTF-8"

    LANG = (unset)

are supported and installed on your system.
This is just a warning indicating your locale are not defined so the system is failing back to the standard locale. To avoid receiving these messages you have 2 options:

* If you are working with Mac, change your terminal preferences: Terminal -> Preferences. Then select the Advanced tab. At the bottom you will see a check box labeled "Set locale environment variables on startup", make sure it is unchecked.

* If you are working on a Linux box, add the following lines to your ``.bashrc`` file (it should be in your IBEX home directory ``~/.bashrc``):

.. code-block:: bash
    :caption: Commands to set locale

    export LANGUAGE=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    export LC_CTYPE=en_US.UTF-8
    export LANG=en_US.UTF-8

Now you can either source your .bashrc file (type ``source ~/.bashrc``) or you can execute a new shell (just type ``bash``) or log out and log back in to make sure it works.

Disk usage and limits (quotas) on Ibex
=======================================

Every file system (disk) on Ibex has its assigned limits, also known as disk quotas. Limits can be assigned per file system, per user or per project.

If you run out of disk space on Ibex you might face the following errors:

* "No space left on device"
* "Disk quota exceeded"
* Other similar errors

The first step to check limits that apply to you, or resolve quota issues, is to identify which file system is in question. 

This can be done by looking at the beginning of the full path to the affected directory.

Simply cd to affected directory and use command pwd ("print working directory"):

.. code-block:: bash
    :caption: Commands to check working directory

    $ pwd
    /ibex/user/my_username/some/dir/subdir/1/2/3/…

Quotas on Home disk:
---------------------

Path starts with: ``/home/username/…``

Relevant command: ``quota -s``

.. note::
    command ``quota -s`` might print a different username than yours - please ignore it. Printed utilisation values will be correct for your account!

Example:

.. code-block:: bash
    :caption: Command to check home quota

    $ quota -s
    Disk quotas for user username (uid 123456):
    Filesystem   space   quota   limit   grace   files   quota   limit   grace
        fs-nfs-60.admin.vis.kaust.edu.sa:/home/home
                2633M    180G    200G           85071   4295m   4295m

Quotas for Personal Computational Space:
-----------------------------------------

Path starts with: ``/ibex/scratch/my_username/…``

Relevant command: ``bquota``

Example:

.. code-block:: bash
    :caption: Command to check scratch quota

    $ bquota
    Quota information for IBEX filesystems:
    Scratch (/ibex/scratch):  Used: 0.00 GB  Limit: 25.00 GB


Path starts with: ``/ibex/user/my_username/…``

Relevant command: ``df -h /ibex/user/my_username``

Example:

.. code-block:: bash
    :caption: Command to check user quota

    $ df -h /ibex/user/my_username
    Filesystem      Size  Used Avail Use% Mounted on
    user            1.5T  8.0K  1.5T   1% /ibex/user

Quotas for Project directories:
--------------------------------

.. note::
    Two file systems are used for non-encrypted projects and one additional file system for encrypted projects (see below).

Path starts with: ``/ibex/scratch/projects/…``

Relevant command: ``bquota -g ibex-c1234``

Example:

.. code-block:: bash
    :caption: Command to check project quota

    $ bquota -g ibex-c2123
    Quota information for IBEX filesystems:
    Fast Scratch        (/ibex/fscratch):   Used:       0.00 GB   Limit:       0.00 GB
    Projects    (/ibex/scratch/projects):   Used:   10740.97 GB   Limit:   20480.00 GB

.. note::
    Make sure that all files in the project directory belong to the unix group associated with the given project. Eg. If your project is "c1234", then the group name would be "ibex-c1234". Avoid putting in the project directory files that belong to personal groups ("g-myusername"). In other cases quota error might be triggered against your Personal Computational Space.

Path starts with: ``/ibex/project/…``

Relevant command: ``df -h /ibex/project/c1234``

Example:

.. code-block:: bash
    :caption: Command to check project quota

    $ df -h /ibex/project/c2247
    Filesystem      Size  Used Avail Use% Mounted on
    project          13T   12T  1.2T  92% /ibex/project

Quotas for Encrypted projects:
-------------------------------

Path starts with: ``/encrypted/…``

Relevant command: ``df -h /encrypted/e1234``

Example:

.. code-block:: bash
    :caption: Commands to check encrypted project quota

    $ df -h /encrypted/e3001
    Filesystem      Size  Used Avail Use% Mounted on
    ddn606-fs1      200T  127T   74T  64% /encrypted/e3001
