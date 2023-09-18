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

The email should be the one your GitHub account is registered with.

Create environment to developing documentation
----------------------------------------------
- Run the following command to create a container and start editing

.. code-block:: bash
  
  ./runner.sh -c
  cd docs

- Once done type `exit` to get out of the container
- To upstream your changes to dev branch on GitHub

.. code-block:: bash
  
  ./runner.sh -u "Some message reflecting the changes"

Testing your changes
---------------------
Once you have done the changes and would like to preview before them before contributing to the dev branch, you will need to compile the code tree:
For this you should be in the container (i.e. the devel envrionment)

.. code-block:: bash

  make html

Once the compilation is successful, you can view the ``docs/build/html/index.html`` in a web browser.


Creating Pull Request from dev to main branch
---------------------------------------------
Once you have pushed your changes to dev branch using ``./runner.sh -u`` "commit message", you can go to GitHub and create a Pull Request. This will be reviewed and if everything is in order, will be merged by the admin to main branch for reflecting the changes.

.. image:: https://img.youtube.com/vi/pi0zkbbvXYo/hqdefault.jpg
      :target: https://www.youtube.com/watch?v=pi0zkbbvXYo
