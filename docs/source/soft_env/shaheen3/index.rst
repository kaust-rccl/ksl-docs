==========
Shaheen 3
==========

Users can benefit from many software packages and scientific libraries available as modules. Users can also compile their source code using various compiler toolchains in the Cray Programming Environment.

*******************
Environment Modules
*******************

Before requesting the installation of new packages or
libraries, please check if the desired package is already
installed on the system.

* To find the list of all the packages installed:

.. code-block:: bash

 module avail

* To find a specific package:

.. code-block:: bash

 module avail -S name

* To get information on the package usage:

.. code-block:: bash

 module help xxxx
 module show xxxx

* To display Cray Scientific Libraries:

.. code-block:: bash

 module avail –L

* To load a module: module:

.. code-block:: bash

 module load xxxxx


.. toctree::
   :maxdepth: 1
   :titlesonly:

*******************
Compiler Toolchains
*******************

Cray, AMD, and GCC compiler toolchains are provided through modules.
The module `PrgEnv-<compiler>` is used to activates the respective toolchain.


