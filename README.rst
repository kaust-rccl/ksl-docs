KSL User Documentation
======================

This is a repository for developing and deploying User documentation for KSL users to use KSL systems. 
It contains documentation on both hardware and software provided on KSL systems and associated best practices to use it.

Pre-requisites
--------------
- Docker should be installed on your host machine
- Git should be installed on your host machine
  - If you haven't already, set your credential configuration for Git, e.g.
 
.. code-block:: bash

    git config --global user.name=Mohsin Ahmed Shaikh 

    git config --global user.email=moshinshaikh786@gmail.com

  - The email should be the one your GitHub account is registered with.

Create environment to developing documentation
----------------------------------------------
- Run the following command to create a container and start editing

.. code-block:: bash
  
  ./runner.sh -c

- Once done type `exit` to get out of the container
- To upstream your changes to dev branch on GitHub

.. code-block:: bash
  
  ./runner.sh -u "Some message reflecting the changes"
