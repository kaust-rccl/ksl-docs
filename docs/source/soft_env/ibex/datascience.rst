Data Science on Ibex
====================

Introduction
------------

Core to our support philosophy is the goal of empowering users to manage their own software stacks and workflows through encouraging the use of Conda (+Pip), containers, and workflow management tools like Snakemake. 
We encourage all Ibex users, but particularly those whose work will focus on data science or machine learning applications, to develop a familiarity with Conda (+Pip). In particular, all Ibex data science users should install Miniconda in their Ibex home directories by following the instructions on GitHub https://github.com/kaust-rccl/ibex-miniconda-install.

1. If you are a new user who just wants to get started with data science on Ibex using Python, then you should start with the machine_learning module. 
The machine_learning module is designed to help new Ibex data science users get up in running quickly without having to install any software or manage their own Conda environments. 
This module has a large collection of recent versions of the most commonly used Python data science packages including Pandas, PyTorch, Scikit-Learn, TensorFlow, RAPIDS, and Jax that are already built to make use of GPUs; the module also includes the core scientific Python libraries such as Dask, NumPy, SciPy, and Xarray. 
For a complete listing of the packages included in the module please see the module’s GitHub repository vi https://github.com/kaust-rccl/ibex-machine-learning-modules/tree/machine-learning-2021.09. 
If you need a package (or a version of a package) that is not already included in the machine_learning module, then you should install Miniconda in your home directories and use Conda to create and manage your own software stack.

2. If you are an advanced user who has production use cases, then you may wish use the dl meta module which is based on the Intel Python distribution (also available via Conda) and includes deep learning libraries that have been compiled to target our hardware. 
Again, if you find that you need a package that is not included inside the Intel Python distribution or a different version of one of the key deep learning frameworks that is not included in the dl meta-module, then you should install Miniconda in your home directory and use Conda (+Pip) manage their own software stack by following the instructions on GitHub https://github.com/kaust-rccl/ibex-miniconda-install

3. Most Ibex data science users will fall somewhere in between the above two extremes. 
If you fall into this category, then you should use Conda (+Pip) to manage your software stack. 
You should install Miniconda in your Ibex home directory by following the instructions on GitHub https://github.com/kaust-rccl/ibex-miniconda-install.

FAQs
----

Why Conda (+Pip) and not just Pip?
----------------------------------

Scientific computing and data science workflows almost always make use of multiple programming languages and paradigms. 
Usually some combination of Python or R, C/C++ and Fortran, and Javascript. 
Many workflows require special libraries for working with accelerators such as GPUs. 
Conda was designed to specifically support scientific computing use cases in general, and data science/machine learning use cases in particular. 
Pip, on the other hand, is a Python specific package manager designed to manage dependencies for Python only projects.

Conda solves both the environment management and the package management problems with a single tool. 
Users who want to use Pip will need to use some other tool to manage their virtual environments.

By default Conda distributes pre-compiled binaries that are optimized for common computing architectures. 
This means that, for the most part, you should not need to bother compiling any code and will still get good performance. 
That said, common compiler toolchains are also available from https://conda-forge.org/: if you do need to compile code, then you can download a compiler and do so while still using Conda (+Pip) to manage your software stack.

Can I use other environment management tools besides Conda on Ibex?
-------------------------------------------------------------------

We recommend that you not use virtual environment tools such as venv, Pipenv, Poetry, etc. 
These virtual environment solutions are strictly inferior to Conda (+pip) for data science use cases. 
Whilst these tools can often be made to work on Ibex, they will not be supported by Ibex staff.

Is there a Conda module that I should use?
------------------------------------------

No, you should install Miniconda in your home directory by following our instructions on https://github.com/kaust-rccl/ibex-miniconda-install.

Can I install Anaconda instead of Miniconda?
--------------------------------------------

You can, but we do not recommend it. 
The Anaconda Python distribution is too large to make a good default environment for you work. 
We strongly encourage you to use separate Conda environments for each of your projects and to keep those Conda environments small (i.e., only install those packages that are necessary for a particular project in that project’s environment).

Should I install Pip in my Ibex home directory as well?
-------------------------------------------------------

No. Instead you will be installing a separate pip package into every one of your Conda environments. 
You will then use the pip package installed in a particular Conda environment to install Python packages that are not available via any Conda channel into that Conda environment.

Should I install packages in my base Conda environment?
-------------------------------------------------------

No! You base Conda environment is used by Conda to interact with the host operating system. 
Installing packages into the base Conda environment can (and will) eventually break the Conda tool and require you to remove and reinstall the entire Miniconda distribution.

Where should I install my Conda environments on Ibex?
-----------------------------------------------------

Conda environments should be installed inside a project directory in the your Ibex scratch directory for optimal performance. 
Your should create an environment.yml file, save the file inside the project directory, and create the Conda environment from this configuration file.

Can you please install my favorite data science package on Ibex?
----------------------------------------------------------------

Your favorite package might already be available in the machine_learning module. 
If the package is available in the machine_learning module, then you should use the machine_learning module to get started quickly. 
If the package is not available in the machine_learning modules, then you should install the package yourself using conda if possible (and pip only if necessary). 
The vast majority of user required software is available on the conda-forge channel (and/or the bioconda channel for bioinformatics and genomics applications). 
You will need to install Miniconda in your Ibex home directory by following instruction on https://github.com/kaust-rccl/ibex-miniconda-install (if they haven’t already done so).

How do I install my favorite data science package on Ibex using Pip?
--------------------------------------------------------------------

The package might already be available in the machine_learning module. 
If package is available in the machine_learning module, you should use the machine_learning module to get started quickly. 
If the package is not available in the machine_learning module, then you should do the following. 
First, install Miniconda in your home directory by following instruction on https://github.com/kaust-rccl/ibex-miniconda-install (if they haven’t already done so). 
Once you have Miniconda installed in your home directory, check if the package is available on the conda-forge Conda channel. 
If the package is available via conda-forge , then you should install the package from conda-forge.
If the package is not available via conda-forge or other common Conda channels, then you should install pip into your Conda environment, activate the Conda environment, and then install the required package. 

My data science project requires GPUs. What modules should I load?
------------------------------------------------------------------

Unless you are using the machine_learning module, none. 
When installing the various GPU accelerated libraries such as TensorFlow, PyTorch, NVIDIA RAPIDS, Jax, et al using Conda (+pip), then required CUDA libraries will automatically be installed. 
User should not need to load any modules.
An exception to the above is when the user requires NVCC. 
The NVIDIA runtime libraries are all distributed via Conda but the runtime libraries do not include NVCC.
In whic case the user should load the cuda module.

