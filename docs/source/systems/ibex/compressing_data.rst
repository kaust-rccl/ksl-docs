Compressing Data 
================

**Compressing Data**

File compression is very useful since it allows you to reduce the amount of space on disk you are using. It is also very useful when you have to transfer files since you transfer a smaller file.

There is, nevertheless a drawback which is: compression uses a lot of CPU. So please do not compress files from the login nodes, run a SLURM script to do that (there's an example at the end of the page).

**Some Advice**
---------------

* not all files are compressible or have the same level of compression:
  
  * big txt files will achieve the best compression ratio
  * media files, such as video, audio and images are most likely already compressed (unless you work with RAW files)
  * other binary files (executables, certain scientific data files, ...) will achieve different compression levels so YMMV

* try to use a parallel compressor since it will lower compression times (more on that later on)
* SLURM is your friend, write a batch job to compress files on a compute node. You don't need very high resources so a 64 GB node will be enough
  
  * defining less than 64 GB will guarantee your compression script will run quickly and not wait for ever in the queue
  * define #SBATCH --mem=50G in your batch script
  * there's a simple example at the end of the page

* BIG NOs

  * DO NOT compress on the login nodes:

    * you will be affecting other users
    * we will kill the process so you will be wasting your time
    * see below, there's an example of a parallel compression SLURM script
    
  * DO NOT compress files which have already been compressed:
    
    * you won't get more compression
  
  * DO NOT compress files that are already compressed with a different compressor
    
    * you won't get more compression
    
  * DO NOT compress:
    
    * media files (audio, video nor images):

      * that's what codecs are for
      * most likely, your media file is already compressed
    
    * ISO images
    * binaries/executables
    * small files (see below)
 
  * DO NOT monitor the SLURM queue constantly, this is a bad habit and DOES NOT improve performance: your job will take just as long whether you look at it or not

**What is a small file**
------------------------

This depends on what you want to do with it. A few examples:

* If the file is less than 1 MB, don't waste your time compressing it (see below)
* if you are going to e-mail it, then yes, compress the file even if it is a few MB in size
* if you are going to ftp/sftp/scp/rsync somewhere in Campus, you can compress it when it goes over 500 MB
* if you are going to ftp/sftp/scp/rsync somewhere outside of the Campus, you can compress it when it goes over 100 MB
* if you are going to archive it (tar), compress it when it's over 1 GB

**I have files smaller than 1 MB, what should I do?**

Your best option here is creating a `tarball <https://en.wikipedia.org/wiki/Tar_(computing)>`_ (some examples below). This allows you to create a file in which you collect other smaller files.

This is useful when you want to:

 * archive data you are not currently using (old data)
 * transfer a lot of small files
 * compress a lot of small files


**Creating a tarball**

DO NOT create tarballs bigger than a couple of hundred GB, it makes working with them unmanageable:

 * slow transfers
 * if the file gets corrupted you lose a lot of data
 * creation of the tarball with many files takes a very long time
 * compression of the tarball takes a very long time
 * the same for decompression and extraction
 * if you have many small files (100,000 4 KB files = 390 MB):
    
    * DO NOT create a single tarball with all the files
    * it's best to create tarballs of up to 5,000 files

Creating the tarball
--------------------

In order to create a tarball you need to use the tar command. This command has a lot of options so we will go over the most used/useful ones here. Remember, adding more options DOES NOT mean a "better" tarball and couls suppose longer creation times.

**DO NOT use compression options** (j or z) because this will be SLOW. Compress the tarball AFTER you have created using parallel compression tools (see below).

.. code-block:: bash
    :caption: Create a simple tarball:

    tar cvf data.tar data

|

.. code-block:: bash
    :caption: Create a tarball preserving the file permissions:

    tar cvfp data.tar data

|

.. code-block:: bash
    :caption: Create a tarball excluding a subdirectory:

    tar -cvfp data.tar data --exclude='data/temp_files' 

This last command creates the data.tar tarball but excludes the temp_files subdirectory


Extracting the contents of a tarball
------------------------------------

Depending on the number of files in the tarball, this can take more or less time.

.. code-block:: bash
    :caption: This command will extract the contents to the current directory:

    tar xvf data.tar

|

.. code-block:: bash
    :caption: If you want to extract the contents to a different directory:

    tar xvf data.tar -C /destination/directory/

|

Listing the contents of a tarball
---------------------------------

.. code-block:: bash
    :caption: Depending on the number of files in the tarball, this can take more or less time:

    tar xvf data.tar -C /destination/directory/

Parallel Compression
---------------------
Traditional compression tools use only 1 core so the compression is slow. Newer compression tools let you use all the cores in a node to compress files so you speed up compression times.

**Parallel Compression Tools**

We currently have 4 parallel compression tools installed on the compute nodes:

 * `pigz <http://zlib.net/pigz/>`_: creates compressed files compatible with gzip
 * `pbzip2 <https://launchpad.net/pbzip2>`_: creates compressed files compatible with bzip2
 * `lbzip2 <http://lbzip2.org/>`_: creates compressed files compatible with bzip2
 * `zstd <https://github.com/facebook/zstd/blob/dev/README.md>`_: new compression tool which is parallelized

These tools have different compression ratios, CPU and memory usage and compression times. If you want a no-brainer, go with pigz: you will be able to decompress on any OS anywhere in the World ;)

There are other traditional compression tools installed on the compute nodes such as: gzip and lrzip but we recommend the parallel compression tools.

SLURM job script to run parallel compression
--------------------------------------------

.. code-block:: bash
    :caption: As mentioned above **DO NOT run compression jobs on the login nodes**, use SLURM to run them on the compute nodes. This is an example of a very simple SLURM job script to compress files:

    #!/bin/bash
    #SBATCH -N 1
    #SBATCH --cpus-per-task=20
    #SBATCH --partition=batch
    #SBATCH -J comp
    #SBATCH -o comp.%J.out
    #SBATCH -e comp.%J.err
    #SBATCH --mem=50G
    #SBATCH --time=00:30:00

    # Compressing with pigz:
    pigz -9 /scratch/dragon/amd/grimanre/files_to_compress/*

|

.. code-block:: bash
    :caption: You can replace the last line with one of the other parallel compression tools, for example:

    pbzip2 /scratch/dragon/amd/grimanre/files_to_compress/*

.. code-block:: bash

    lbzip2 /scratch/dragon/amd/grimanre/files_to_compress/*    

.. code-block:: bash

    zstd -z -19 -T0 /scratch/dragon/amd/grimanre/files_to_compress/*