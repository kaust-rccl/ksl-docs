.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: monogodb ibex container example
    :keywords: krccl, container, mongodb, ibex

.. _mongodb_ibex_container_example:

===================================
MongoDB on compute nodes of ibex
===================================

In this page, we will explore how to launch a mongoDB server on a ibex compute node and then connect to it from another compute node of ibex interactively.

The server launched will be submitted as a batch job to SLURM and can run for no more than 24 hours.

We will use mongo from a singularity container. Singularity has provided a Singularity Definition file or def file to create a mongo image. This can done exclusively on a Ibex compute node.


Ibex Jobscript to create mongo image file
=========================================

.. note::

    For this step, you should be able to run a job on Ibex cluster.

First clone the git repository containing the Singularity definition file to create the image:

.. code-block:: bash

    cd $HOME
    git clone https://github.com/singularityhub/mongo.git

The jobscript looks as follows: 

.. code-block:: bash

    #!/bin/bash
    #SBATCH --time=01:00:00
    #SBATCH --ntasks=1

    module load singularity
    cd $HOME/mongo
    export XDG_RUNTIME_DIR=$HOME
    singularity build --fakeroot mongo.sif Singularity

A successful completion should result in creation of a singularity image file mongo.sif. 

Working with the image:
=======================

Copy or move your image file :code:`mongo.sif`` to somewhere in your weka directory. For example, I have copied mine in :code:`/ibex/user/$USER/mongo_test`.  Mongo DB requires a write permitted space to do some housekeeping for the database. We need to create a directory, e.g. data, and bind it when launching the database instance.

.. code-block:: bash

    cd /ibex/user/$USER/mongo_test
    mkdir data

Here is how the database launch jobscript looks like:

.. code-block:: bash

    #!/bin/bash
    #SBATCH --time=00:30:00
    #SBATCH --nodes=1

    # Remove old .out files except the current job's output file
    find . -maxdepth 1 -name "*.out" ! -newer $0 -exec rm -f {} \;

    module load singularity
    #Grep the IP address for Cray Aries interface
    export IP_ADDR=$(ifconfig ibo | grep 'inet ' | awk '{print $2}')

    export PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')

    echo IP_ADDRESS=$IP_ADDR
    echo PORT=${PORT}

    cd /ibex/user/$USER/mongo_test
    singularity run ./mongo.sif mongod --noauth --bind_ip localhost,${IP_ADDR} --port $PORT --dbpath=$PWD/data

The above jobscript should launch a mongodb daemon in a secure manner. Now we are ready to connect with it. Let’s connect our client. Note the IP address and port from the :code:`slurm-xxxxxx.out` file where the database server was running, e.g. :code:`IP_ADDRESS=10.109.203.152 \n PORT=41067`

Load the singularity module and ask for an interactive session with the :code:`srun` command : 

.. code-block:: bash

    module load singularity
    srun --time=00:30:00 --nodes=1 --pty singularity exec -B $PWD/data:/data/db $PWD/mongo.sif mongosh --host 10.109.203.152 --port 41067

After the resources are allocated you will see the output like this below:

.. code-block:: bash

    srun: job 22878644 queued and waiting for resources
    srun: job 22878644 has been allocated resources
    Current Mongosh Log ID:	6374e621ec85174afd042398
    Connecting to:		mongodb://10.109.203.152:41067/?directConnection=true&appName=mongosh+1.6.0
    Using MongoDB:		6.0.2
    Using Mongosh:		1.6.0

    For mongosh info see: https://docs.mongodb.com/mongodb-shell/


    To help improve our products, anonymous usage data is collected and sent to MongoDB periodically (https://www.mongodb.com/legal/privacy-policy).
    You can opt-out by running the disableTelemetry() command.

    ------
    The server generated these startup warnings when booting
    2022-11-16T16:16:36.057+03:00: /sys/kernel/mm/transparent_hugepage/enabled is 'always'. We suggest setting it to 'never'
    2022-11-16T16:16:36.058+03:00: /sys/kernel/mm/transparent_hugepage/defrag is 'always'. We suggest setting it to 'never'
    2022-11-16T16:16:36.058+03:00: vm.max_map_count is too low
    ------

    ------
    Enable MongoDB's free cloud-based monitoring service, which will then receive and display
    metrics about your deployment (disk utilization, CPU, operation statistics, etc).
    
    The monitoring data will be available on a MongoDB website with a unique URL accessible to you
    and anyone you share the URL with. MongoDB may use this information to make product
    improvements and to suggest MongoDB products and deployment options to you.
    
    To enable free monitoring, run the following command: db.enableFreeMonitoring()
    To permanently disable this reminder, run the following command: db.disableFreeMonitoring()
    ------

    test> 

.. note::

    Since mongod launched in the Jobscript is listening on Cray Aries interconnect, it is necessary that the client runs on a compute node to connect to the IP address of the device where this server is running. The client won’t run on login node.

    The legacy mongo shell is no longer included in server packages as of MongoDB 6.0. mongo has been superseded by the mongosh
    https://www.mongodb.com/docs/mongodb-shell/

Using pymongo Driver
====================

Once the Mongo server is running usingmongod as described above, we can interact with it using :code:`pymongo` driver, the defacto way to use MongoDB from within python.

Following is an example python script:

.. code-block:: bash

    #Import pymongo
    from pymongo import MongoClient
    import sys,datetime

    # Creation of a new database
    def create_db(client,db_name="mydatabase"):
        db = client[db_name]
        return db

    # Creation of a new collection in a particular database
    def create_collection(db,coll_name="mycol"):
        coll = db[coll_name]
        return coll 


    if __name__=="__main__":
        host=sys.argv[1]
        client= MongoClient(host, port)
        db    = create_db(client,"myFirstDB")
        col   = create_collection(db,"myFirstCol")

    # The following is our entry we wish to add to our collection in database    
        post = {"author": "Mike",
                "text": "My first blog post!",
                "tags": ["mongodb", "python", "pymongo"],
                "date": datetime.datetime.utcnow()}
        post_id = col.insert_one(post).inserted_id

        print("post ID inserted: ",post_id)
        print("Existing databases:",client.list_database_names())
        print("Existing collections:",db.list_collection_names())

The above test can run in a separate jobscript. We need to parse the IP address where our MongoDB is running. This is printed in the first line of the slurm output file of the MongoDB server job we submitted. E.g. our server is running on IP address: :code:`10.109.203.152`.

The following jobscript can be submitted to run the client which launches pymongo python test.

.. code-block:: bash

    #!/bin/bash
    #SBATCH --time=01:00:00
    #SBATCH --nodes=1
    #SBATCH --cpus-per-task=12
    #SBATCH --hint=multithread

    module load pymongo
    DB_HOST=${1}
    DB_PORT=${2}
    python pymongo_test.py ${DB_HOST} ${DB_PORT}

.. code-block:: bash

    sbatch client.slurm 10.109.203.152 41067 

Output looks as follows:

.. code-block:: bash

    post ID inserted:  60268b1ab9e7406373dd8442
    Existing databases: ['admin', 'config', 'local', 'myFirstDB']
    Existing collections: ['myFirstCol']


Using mongodump
===============

To create a binary dump of the database and/or a collection, one can run it as a separate job. The following example jobscript creates a :code:`gzip` archive of an existing database. It is assumed here that a mongodb server is already running as has been described above. Given that the IP address of the host of this server is :code:`10.109.203.152` and port is :code:`41067`

.. code-block:: bash

    #!/bin/bash

    #SBATCH --time=01:00:00
    #SBATCH --nodes=1

    module load singularity

    srun singularity run ./mongo.sif mongodump --host=10.109.203.152 --port=41067 --db myFirstDB --collection myFirstCol --gzip --archive > data_$(date "+%Y-%m-%d").gz

This should create a file :code:`data_2021-02-24.gz` (date may vary) in your present working directory.

Once run the above command as an interactive operation in a :code:`salloc` session:

.. code-block:: bash

    > salloc
    > module load singularity
    > srun --pty singularity shell ./mongo.sif
    > mongodump --host=10.109.203.152 --port=41067 --db myFirstDB --collection myFirstCol --gzip --archive > data_$(date "+%Y-%m-%d").gz
    > exit
    > exit

Using mongorestore
------------------

Once you have a compressed dump of your database/collection, you can copy to a remote destination to restore your database there. For instance, if we have a compressed file :code:`data_2021-02-24.gz` I can :code:`scp` to my workstation/laptop where I have a mongodb installation and restore there.

.. note::

    I installed mongodb in a conda environment.  

First, I start a new mongodb server on my local machine on :code:`localhost`:

.. code-block:: bash

    mkdir -p $PWD/data/db
    mongod --dbpath ./data/db

Now we can start the restoration step in a new terminal:

.. code-block:: bash

    gzip -d data_2021-02-24.gz

.. code-block:: bash

    mongorestore --archive=data_2021-02-24    
    2021-02-24T17:26:59.010+0300	preparing collections to restore from
    2021-02-24T17:26:59.019+0300	reading metadata for myFirstDB.myFirstCol from archive 'data_2021-02-24'
    2021-02-24T17:26:59.084+0300	restoring myFirstDB.myFirstCol from archive 'data_2021-02-24'
    2021-02-24T17:26:59.087+0300	no indexes to restore
    2021-02-24T17:26:59.087+0300	finished restoring myFirstDB.myFirstCol (1 document)
    2021-02-24T17:26:59.087+0300	done

Let us see if it has been ingested in our mongodb server:

.. code-block:: bash

    mongo 
    MongoDB shell version v4.0.3
    connecting to: mongodb://127.0.0.1:27017
    Implicit session: session { "id" : UUID("de99ba6c-77e1-44d4-9c58-49af3270b992") }
    MongoDB server version: 4.0.3
    .......
    > dbs
    2021-02-24T17:27:26.160+0300 E QUERY    [js] ReferenceError: dbs is not defined :
    @(shell):1:1
    > db
    test
    > show dbs
    admin      0.000GB
    config     0.000GB
    local      0.000GB
    myFirstDB  0.000GB
    > use myFirstDB
    switched to db myFirstDB
    > show collections
    myFirstCol

