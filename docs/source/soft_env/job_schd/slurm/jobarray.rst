.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: SLURM job arrays
    :keywords: SLURM, job, array 

.. _slurm_jobarrays:

===========
Job Arrays 
===========
Submitting Arrays
Array jobs are much like single job submissions with a few exceptions:

Array jobs have the additional ``#SBATCH --array=N-M[:S]`` argument specifying N = start, M = end, S = step size for the array ID range.
The submitted script will be executed once for each array ID, setting these variables to appropriate values each time:
``SLURM_ARRAY_JOB_ID = The JOBID of this task.``
``SLURM_ARRAY_TASK_ID = The task ID of this task.``

.. code-block:: bash
    :caption:  A simple array example script is:


    #!/bin/bash
    #SBATCH --job-name=ArrayJobScript
    #SBATCH --time=10:00
    #SBATCH --nodes=1
    #SBATCH --ntasks=1
    #SBATCH --array=0-4

    # Print some job information
    echo
    echo "My hostname is: $(hostname -s)"
    echo "I am job $SLURM_JOB_ID"
    echo "I am a member of the job array $SLURM_ARRAY_JOB_ID"
    echo "My task ID is $SLURM_ARRAY_TASK_ID"
    echo

    # Sleep for 1 minutes
    sleep 60s

Using ``$SLURM_ARRAY_TASK_ID`` As A Parameter
Within an array job script, the SLURM_ARRAY_TASK_ID value can be used to change the scripts behavior for each element job in the array. For example, suppose you have an application with takes a parameter as an argument that is an integer value and you wish to test different values over a range from 1 to 10. A script for this might look like:

.. code-block:: bash
    :caption:  A simple script example is:

    #!/bin/bash
    #SBATCH --job-name=ParameterTesting
    #SBATCH --time=10:00
    #SBATCH --nodes=1
    #SBATCH --ntasks=1
    #SBATCH --array=1-10

    # Imagine the sleep command is a powerful model taking one parameter. 
    sleep $SLURM_ARRAY_TASK_ID

Reading Multiple Arbitrary Parameters Based on ``$SLURM_ARRAY_TASK_ID``
An arbitrary number of key-value pairs can be associated with each SLURM_ARRAY_TASK_ID by having the job script read a file which is indexed on SLURM_ARRAY_TASK_ID and has the values in some known arrangement that can be extracted. An example of this approach is these two files, first the indexed file of values with values delimited by colons:
 
.. code-block:: bash

    0:10:28:1.657:80.0023
    1:12:14:0.324:32.9
    2:1:7:9.41:16.8

.. code-block:: bash
    :caption: Next, the array script which processes them:

    #!/bin/bash

    #SBATCH --job-name=ArrayIndexFileExample
    #SBATCH --time=10:00
    #SBATCH --nodes=1
    #SBATCH --ntasks=1
    #SBATCH --array=0-2

    # Print some job information
    echo
    echo "My execution hostname is: $(hostname -s)."
    echo "I am job $SLURM_JOB_ID, a member of the job array $SLURM_ARRAY_JOB_ID"
    echo "and my task ID is $SLURM_ARRAY_TASK_ID"
    echo

    # We expect this file to be in the working directory. Use full path if it's not.
    # Values are grabbed by selecting the line that begins with the 
    # SLURM_ARRAY_TASK_ID
    values=$(grep "^${SLURM_ARRAY_TASK_ID}:" array_index.txt)

    # Cut each individual value from it's corresponding position in the line we
    # pulled out above.
    param1=$(echo $values | cut -f 2 -d:)
    param2=$(echo $values | cut -f 3 -d:)
    param3=$(echo $values | cut -f 4 -d:)

    # Echo this out for illustration, but in practice we would just run the
    # command.
    echo "command -arg1=$param1 -arg2=$param2 -arg3=$param3"

When ran the script will use the ``SLURM_ARRAY_TASK_ID`` to pull out the values for each job array element. As this script demonstrates, the task id can be used to access any number of arbitrary command, arguments, scripts, files, etc, making job arrays a very powerful feature for parallelizing tasks requiring no intercommunication between each task.

Using $SLURM_ARRAY_TASK_ID To Process A List Of Items
Given a list of items, one per line in a file, it's easy to use an array to process each item. Note that it's also possible to adjust which lines get processed with the array specification. For instance, If you only wanted to process lines 100 - 120, simply use --array=100-120. The list could be as simple as a list of files prepared by ls -1 > mylistfofiles.txt or as complicated as a list of full command lines to execute in individual jobs.

.. code-block:: bash
    :caption: an example list 

    This is line 1.
    And now we have line 2.
    After 1 and 2 comes line 3.
    2 + 2 is 4.
    5 is a prime number.
    A hexagon has 6 sides.
    "Prime 7 is." (Yoda during a short stint as a math teacher.)
    There are only 10 kinds of people, those who understand octal and ... nevermind.

.. code-block:: bash
    :caption: Next, the array script which processes the list items:

    ###ShellExample
    #!/bin/bash

    #SBATCH --job-name=ArrayLinesFromFileExample
    #SBATCH --time=10:00
    #SBATCH --nodes=1
    #SBATCH --ntasks=1
    #SBATCH --array=1-8

    # Print some job information
    echo
    echo "My execution hostname is: $(hostname -s)."
    echo "I am job $SLURM_JOB_ID, a member of the job array $SLURM_ARRAY_JOB_ID"
    echo "and my task ID is $SLURM_ARRAY_TASK_ID"
    echo

    # We expect this file to be in the working directory. Use full path if it's not.
    value=$(sed -n "${SLURM_ARRAY_TASK_ID}p" array_lines.txt)

    echo "command ${value}"

Advanced Array Specifications
The ``--array=`` specification can takes on some additional syntax which makes it even more useful. Some examples:

* ``--array=0-100:4`` : Results in array task IDs of 0,4,8,12,16,...100
* ``--array=0-50%5``: Results in 51 tasks numbered 0-50 but limits them to now more than 5 running tasks at any one time.
* ``--array=2,34,5,6,89,1,23`` : Creates specifically numbered tasks from the list.