Job Dependency
----------------
 
During the workflow development, some of the jobs should be scheduled based on various job dependency conditions like after successful, after termination/failure, after the event etc. upon the previous jobs. The SLURM scheduler uses sbatch command to submit the jobs and it's track the job dependency feature using --dependency (or -d) section. Therefore, the current job dependencies are used to defer the start of a job until the specified dependencies have been satisfied. The general syntax for the job dependency condition is:  

``sbatch --dependency=<type:job_id[:job_id][,type:job_id[:job_id]]> ...``

Where,

.. code-block:: bash 

     job_id : is the previously submitted job id.

     type: is anyone of the below conditions:

``after``: This job can begin execution after the specified jobs have begun execution.

``afterany``: This job can begin execution after the specified jobs have terminated.

``aftercorr``: A task of this job array can begin execution after the corresponding task ID in the specified job has completed successfully (ran to completion with an exit code of zero).

``afternotok``: This job can begin execution after the specified jobs have terminated in some failed state (non-zero exit code, node failure, timed out, etc).

``afterok``: This job can begin execution after the specified jobs have successfully executed (ran to completion with an exit code of zero).

``expand``: Resources allocated to this job should be used to expand the specified job. The job to expand must share the same QOS (Quality of Service) and partition. Gang scheduling of resources in the partition is also not supported.

``singleton``: This job can begin execution after any previously launched jobs sharing the same job name and user have terminated. In other words, only one job by that name and owned by that user can be running or suspended at any point in time.

Additionally, the comma (,) and question (?) separators are used to combine the job dependency condition. 

For example: 
^^^^^^^^^^^^

1. When the job requires more than one job to be completed before it is executed, the comma (,) separator is used for all the jobids.  
 
 ``sbatch --dependency=type:job_id,job_id,job_id ...`` 

2. When the job requires to run if any one of the job ids completes successfully using a ? separator
 
 ``sbatch --dependency=type:job_id?job_id?job_id ...``

Job dependency examples:
========================

First job will generate 1000 random numbers and the second job will find the existance of any specific number (e.g. 9999).  

.. code-block:: bash
    :caption: The example job script file (job_script.sh) will be: 
     
    $ cat job_script.sh 

     #!/bin/bash

     ## Submit First job

     First_ID=$(sbatch --partition=batch --job-name=random_number_generation --time=30:00 --output=First-job%J.out --error=First-job%J.err --nodes=1 --cpus-per-task=1 --parsable --wrap="sh ./random.sh");
     echo "First Job(random_number_generation) submitted and the job id is " ${First_ID};
    ## Execute the Second job only when First job is successful

    Second_Job="sbatch --partition=batch --job-name=Second_Step --time=30:00 --output=Second-%J.out --error=Second-%J.err --nodes=1";
    Second_ID=$(sbatch --partition=batch --job-name=find_existance --time=30:00 --output=Second-job%J.out --error=Second-job%J.err --nodes=1 --cpus-per-task=1 --parsable --dependency=afterok:${First_ID} --wrap="sh ./existance.sh");
    echo " Second Job (find_existance)  was submitted (Job_ID=${Second_ID}) and it will execute when the First Job_ID=${First_ID} is successful"

Where, 

The first job, random number generated script will be (random.sh)

.. code-block:: bash

     $ cat random.sh 

    #!/bin/bash

    echo "1000 Random numbers generation ... started";

    rm -Rf random.numbers.out

    RANDOM=$$

    for i in `seq 1000`;

    do 

    echo $RANDOM >> random.numbers.out ;

    sleep 100;

    done 

    echo "1000 Random numbers generation ... completed";

.. code-block:: bash
    :caption:  The second job, find the existance of the specific number script (existance.sh) will be:

    $ cat existance.sh 

    #!/bin/bash

    echo "Finding the existance of 9999 number in the file: random.numbers.out"

    cat random.numbers.out | grep  "9999"

.. code-block:: bash
    :caption:  After the job submission, the job ids are generated from SLURM as, 
    
    First Job(random_number_generation) submitted and the job id is  808979

    Second Job (find_existance)  was submitted (Job_ID=808980) and it will execute when the First Job_ID=808979 is successful