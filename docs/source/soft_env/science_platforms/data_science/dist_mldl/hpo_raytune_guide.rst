Automated Hyperparameter Optimization (HPO) with Ray Tune
=========================================================

`Ray <https://docs.ray.io/en/latest/index.html#>`__ is an open-source
framework designed to scale Python and ML/DL workloads seamlessly across
clusters and cloud environments. `Ray
Tune <https://docs.ray.io/en/latest/tune/index.html>`__, part of the Ray
ecosystem, enables efficient hyperparameter tuning at any scale. It
integrates with popular machine learning frameworks such as PyTorch,
TensorFlow, Keras, and XGBoost, leveraging proven search algorithms to
identify optimal hyperparameter combinations for objectives like
minimizing loss or maximizing accuracy. Additionally, Ray Tune provides
flexible scheduling and resource management to optimize computational
efficiency and reduce experiment time.

Introduction
------------

This guide focuses on **Hyperparameter Optimization (HPO)** for
fine-tuning large language models.

You will experiment with both **manual and automated** approaches to
explore how different hyperparameter affect model **performance and
training cost**. 

1. `Baseline manual experiment <#baseline-manual-experiment>`__ 
2. `Automated HPO with Ray Tune using ASHA scheduler <#automated-hpo-with-ray-tune-using-asha-scheduler>`__ 
3. `Additional Experiment using Population-Based Training (PBT) and Bayesian Optimization <#additional-experiments>`__ 

.. Note::
   This guide focuses on running the experiments step by step. For deeper insights into the scripts, internal configurations, and implementation details, please see the accompanying repository `Kaust-rccl/HPO with Ray <https://github.com/kaust-rccl/hpo-with-ray/tree/master>`__

Key Concepts
------------

Before we proceed, let’s review some essential concepts

What is Hyperparameter Optimization (HPO)?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- It’s the process of finding the **best set of hyperparameter** (like
  learning rate, batch size, weight decay) that lead to the **best model
  performance**.
- Proper tuning can significantly reduce training time, GPU usage, and
  improve evaluation metrics.

+-----------------------+-----------------------+-----------------------+
| Hyperparameter        | Objective             | Details               |
+=======================+=======================+=======================+
| **Learning Rate       | Controls how much the | Too high → unstable   |
| (lr)**                | model updates weights | training.Too low →    |
|                       | after each training   | very slow             |
|                       | step.                 | convergence.          |
+-----------------------+-----------------------+-----------------------+
| **Weight Decay (wd)** | A form of             |                       |
|                       | regularization that   |                       |
|                       | prevents over-fitting |                       |
|                       | by penalizing large   |                       |
|                       | weights.              |                       |
+-----------------------+-----------------------+-----------------------+
| **Batch Size (bs)**   | Number of samples     | Larger batches can    |
|                       | processed before      | speed up training but |
|                       | updating model        | need more GPU memory. |
|                       | weights.              |                       |
+-----------------------+-----------------------+-----------------------+

Evaluation Metrics
~~~~~~~~~~~~~~~~~~

+-----------------------------------+-----------------------------------------------------------------+
| Metric                            | Details                                                         |
+===================================+=================================================================+
| **Evaluation Loss (eval_loss)**   | Measures how well the model predicts on the validation dataset. |
|                                   |                                                                 |
|                                   | Lower is better (indicates better generalization).              |
+-----------------------------------+-----------------------------------------------------------------+
| **GPU Hours**                     | Total amount of GPU time consumed.                              |
|                                   |                                                                 | 
|                                   | 1 GPU hour = 1 GPU used for 1 hour (e.g., 4 GPUs × 30 minutes = |
|                                   | 2 GPU hours)                                                    |
|                                   |                                                                 |
|                                   | Useful for comparing cost-efficiency of different methods.      |
+-----------------------------------+-----------------------------------------------------------------+


Introduction to Ray Tune (Automated HPO Framework)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

It’s a Python library for distributed hyperparameter optimization, that **automates running multiple experiments** in parallel and **selecting
the best configurations**. Saves time and GPU resources by **intelligently stopping poor-performing trials early** and focusing on promising ones.

Ray Tune Schedulers Overview
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Schedulers decide how trials are run, paused, or stopped:

+-----------------------------------+-----------------------------------+
| Scheduler                         | Details                           |
+===================================+===================================+
| **ASHA (Asynchronous Successive   | It starts many trials with        |
| Halving Algorithm)**              | different hyperparameter          |
|                                   | combinations, then periodically   |
|                                   | **stops the worst-performing      |
|                                   | trials early** to free resources  |
|                                   | for better ones.                  |
|                                   |                                   |
|                                   | Best used for                     |
|                                   | **fast**, exploratory HPO where   |
|                                   | you want to **test many           |
|                                   | configurations quickly**.         |
+-----------------------------------+-----------------------------------+
| **PBT (Population-Based           | It starts with a **“population”** |
| Training)**                       | of trials, then periodically      |
|                                   | **copies the weights and          |
|                                   | hyperparameter from               |
|                                   | top-performing trials to worse    |
|                                   | ones**.                           |
|                                   |                                   |
|                                   | Also mutates (perturbs)           |
|                                   | hyperparameter dynamically        |
|                                   | **during training**\.             |
|                                   |                                   |
|                                   | Best used                         |
|                                   | for **long-running training**     |
|                                   | where hyperparameter might need   |
|                                   | to **change over time**.          |
|                                   |                                   |
|                                   | The “best                         |
|                                   | hyperparameter” at the end are    |
|                                   | only the final phase’s values;    |
|                                   | the best weights depend on the    |
|                                   | entire sequence of changes.       |
+-----------------------------------+-----------------------------------+
| **Bayesian (Bayesian Optimization | Combines **Bayesian               |
| with HyperBand - BOHB)**          | Optimization** (learns from past  |
|                                   | trials to suggest better          |
|                                   | hyperparameter) with              |
|                                   | **HyperBand** (efficient          |
|                                   | early-stopping strategy).         |
|                                   |                                   |
|                                   | Starts                            |
|                                   | with many short trials and        |
|                                   | **promotes the best ones** for    |
|                                   | longer training, refining them    |
|                                   | with **probabilistic              |
|                                   | guidance**.                       |
|                                   |                                   |
|                                   | Best used when you                |
|                                   | have a **limited GPU budget** and |
|                                   | want to balance **smart search**  |
|                                   | with **efficient resource         |
|                                   | use**.                            |
|                                   |                                   |
|                                   | Unlike ASHA, BOHB doesn’t         |
|                                   | just explore randomly — it builds |
|                                   | a **model of the search space**   |
|                                   | and chooses configurations based  |
|                                   | on **predicted performance**.     |
+-----------------------------------+-----------------------------------+

Introduction to DeepSpeed
~~~~~~~~~~~~~~~~~~~~~~~~~

`DeepSpeed <https://www.deepspeed.ai/>`__ is an optimization library designed for **scaling and accelerating deep learning training**, especially for large models like BLOOM.

In this workshop, DeepSpeed is used to: 

- **Reduce memory usage** via ZeRO Stage 3 optimization. 
- **Enable mixed precision training** (``fp16``) for faster computation and lower memory. 
- **Automatically scale** batch sizes to maximize GPU utilization. 
- **Train large models** efficiently on limited hardware (e.g., 1–2 GPUs).

It integrates seamlessly with Hugging Face’s ``Trainer`` and requires only a config file — no modification to training code is needed.

.. note::
   For a full breakdown of the DeepSpeed config used in this workshop, navigate through the repo 
   `Deepspeed configuration in kaust-rccl/hpo-with-ray <https://github.com/kaust-rccl/hpo-with-ray/blob/master/deepspeed/config/README.md>`__

Initial Setup
-------------

This repository `Kaust-rccl/HPO with Ray <https://github.com/kaust-rccl/hpo-with-ray/tree/master>`__
is organized into modular directories for code, configuration, and experiments.

Starting with cloning the repo:

.. code:: bash

   git clone https://github.com/kaust-rccl/hpo-with-ray.git
   cd hpo-with-ray/deepspeed

**Repository Structure**

.. code:: text

   .
   ├── deepspeed/
   │   ├── config/                  # DeepSpeed configuration files
   │   │   ├── ds_config.json       # ZeRO-3 + FP16 training config
   │   │   └── README.md            # Explanation of the config fields
   │
   ├── experiments/                # SLURM job scripts and run setups
   │   ├── manual/                 # Manual grid search HPO
   │   │   ├── bloom_hpo_manual.slurm
   │   │   └── README.md
   │   └── raytune/
   │       ├── scheduler/
   │       │   ├── asha/           # ASHA-based Ray Tune setup
   │       │   │   ├── head_node_raytune_asha_hpo.slurm
   │       │   │   ├── worker_node_raytune_asha_hpo.slurm
   │       │   │   └── README.md
   │       │   ├── bayesian/       # BOHB setup (Bayesian Optimization with HyperBand)
   │       │   │   └── README.md
   │       │   └── pbt/            # Population-Based Training setup
   │       │       └── README.md
   │       └── README.md           # Ray Tune general overview
   │
   ├── scripts/                    # Python training scripts
   │   ├── manual/
   │   │   ├── bloom_hpo_manual.py # Runs single grid search config
   │   │   └── logs_parser.py      # Parses manual run logs into CSV
   │   └── raytune/
   │       ├── scheduler/
   │       │   ├── asha/raytune_asha_hpo.py
   │       │   ├── bayesian/README.md
   │       │   └── pbt/README.md
   │       └── README.md           # Ray Tune script overview
   │
   └── README.md                   # Main workshop overview and grouping instructions

Environment Setup
-----------------

To run the Ray Tune experiments, you’ll need a properly configured Conda environment.

1. If you haven’t installed conda yet, please follow `using conda on Ibex
   guide <https://docs.hpc.kaust.edu.sa/soft_env/prog_env/python_package_management/conda/ibex.html#conda-ibex>`__
   to get started.

2. Build the conda environment required using the recommended yml file in the project directory, using command:

.. code:: bash

   conda env create -f environment/hpo-raytune.yml

.. note::

   The Conda environment should be built on an allocated GPU node.
   Please ensure you allocate a GPU node before starting the build.

Running Experiments with Ray Tune
---------------------------------

In this project, you will go through experimenting the three schedulers [asha, bayesain, pbt]

.. note::
   
   All runs were performed using the same SQuAD subset, model
   configuration, and DeepSpeed setup for fair comparison.

Baseline: Manual Experiment
~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this `baseline experiment <https://github.com/kaust-rccl/hpo-with-ray/tree/master/deepspeed/experiments/manual>`__,
we manually perform hyperparameter optimization (HPO) by iterating through a predefined grid of parameters, including learning rate, batch size, and weight decay.

Experiment Setup
^^^^^^^^^^^^^^^^

- The SLURM script `bloom_hpo_manual.slurm <https://github.com/kaust-rccl/hpo-with-ray/blob/master/deepspeed/experiments/manual/bloom_hpo_manual.slurm>`__
  manages job submission, environment setup, and iteration control.
- While the Python script (bloom_hpo_manual.py) handles data preprocessing, model fine-tuning, and evaluation.

Running the Experiment
^^^^^^^^^^^^^^^^^^^^^^

To run the manual experiment job:

.. code:: bash

   cd hpo-with-ray/deepspeed/experiments/manual
   sbatch bloom_hpo_manual.slurm

Results
^^^^^^^

- The outputs are logged under directory logs/-.out

- Here are example output for reference:

  == ====== == ==== ================== =========
  #  lr     bs wd   eval_loss          runtime_s
  == ====== == ==== ================== =========
  1  1e-05  1  0.0  9.720768928527832  963.49
  2  1e-05  1  0.01 9.720768928527832  962.06
  3  1e-05  1  0.01 9.720768928527832  962.63
  4  1e-05  2  0.0  10.004271507263184 600.88
  5  1e-05  2  0.0  10.004271507263184 600.64
  6  1e-05  2  0.01 10.004271507263184 603.96
  7  1e-05  2  0.01 10.004271507263184 604.13
  8  0.0002 1  0.0  30.220291137695312 1109.93
  9  0.0002 1  0.0  30.220291137695312 1110.14
  10 0.0002 1  0.01 30.220291137695312 1088.39
  11 0.0002 1  0.01 30.220291137695312 1088.09
  12 0.0002 2  0.0  21.152585983276367 725.37
  13 0.0002 2  0.01 21.152585983276367 727.05
  14 5e-06  1  0.0  9.334717750549316  911.04
  15 5e-06  1  0.01 9.334717750549316  917.87
  16 5e-06  2  0.0  9.569835662841797  513.53
  17 5e-06  2  0.01 9.569835662841797  518.2
  == ====== == ==== ================== =========

Additional Tuning
^^^^^^^^^^^^^^^^^

1. You can modify the defined Hyperparameter grid array defined inside the `bloom_hpo_manual.slurm <https://github.com/kaust-rccl/hpo-with-ray/blob/master/deepspeed/experiments/manual/bloom_hpo_manual.slurm>`__ 
   
   .. code:: bash

      LRs=(1e-5 2e-4 5e-6)
      BSs=(1 2)
      WDs=(0.0 0.01)

Automated HPO with Ray Tune Using ASHA Scheduler
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this exercise, we perform automated hyperparameter optimization using
Ray Tune’s ASHA (Asynchronous Successive Halving Algorithm) scheduler.
Unlike the manual grid search, ASHA runs multiple trials concurrently
and stops poor-performing trials early, freeing resources for more
promising ones.

.. _experiment-setup-1:

Experiment Setup
^^^^^^^^^^^^^^^^

- The training is handled by a Python script
  `raytune_asha_hpo.py <https://github.com/kaust-rccl/hpo-with-ray/blob/master/deepspeed/scripts/raytune/scheduler/asha/raytune_asha_hpo.py>`__.
- While job orchestration on the HPC cluster is handled by the two SLURM
  scripts:

  1. Head node launcher:
     `head_node_raytune_asha_hpo.slurm <https://github.com/kaust-rccl/hpo-with-ray/blob/master/deepspeed/experiments/raytune/scheduler/asha/head_node_raytune_asha_hpo.slurm>`__
  2. Worker node launcher:
     `worker_node_raytune_asha_hpo.slurm <https://github.com/kaust-rccl/hpo-with-ray/blob/master/deepspeed/experiments/raytune/scheduler/asha/worker_node_raytune_asha_hpo.slurm>`__

Breaking Down the Building Block
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 25 75

   * - Component
     - Description

   * - **Training Python File**
     - - Loads and preprocesses the dataset.
       - Sets up the model.
       - Integrates Ray Tune.
       - Defines the hyperparameter search space:

         .. code:: py

            "train_loop_config": {
                "lr": tune.loguniform(5e-6, 2e-4),
                "per_device_bs": tune.choice([1, 2]),
                "wd": tune.choice([0.0, 0.01])
            }

       - Configures the ASHA scheduler:

         .. code:: py

            scheduler = tune.schedulers.ASHAScheduler(
                metric="eval_loss",
                mode="min",
                grace_period=1,
                max_t=5,
                reduction_factor=2
            )

   * - **SLURM Scripts**
     - - Follows similar preparation steps as the manual run
         (environment, CUDA, Conda, logging).
       - Adjusted to enable distributed and concurrent Ray trials.
       - **Head Node Script:**
            - Logs start/end times via ``trap``.
            - Starts a Ray head node with dynamic dashboard/worker ports.
            - Spawns worker jobs automatically (``worker_node_v100.slurm``).
            - Runs ``bloom_ray_tune.py`` once; Ray schedules trials.
       - **Worker Node Script:**
            - Not used in manual HPO.
            - Joins the Ray head node to run concurrent trials.
            - Allocates full node resources (e.g., 8×V100 GPUs per worker).

.. note::
   For more additional details, refer to the Github repo for `Ray-Tune (ASHA Scheduler)
   HPO <https://github.com/kaust-rccl/hpo-with-ray/tree/master/deepspeed/experiments/raytune/scheduler/asha>`__.

.. _running-the-experiment-1:

Running the Experiment
^^^^^^^^^^^^^^^^^^^^^^

1. To run the manual experiment job, make sure you are in the same directory of the experiment:
   
   .. code:: bash

      cd hpo-with-ray/deepspeed/experiments/raytune/scheduler/asha

2. Submit the job using *sbatch*, and optionally override the search space hyperparameter using environment variables:
   
   .. code:: bash

      LR_LOWER=1e-5 \
      LR_UPPER=2e-4 \
      BS_CHOICES="1 2" \
      WD_CHOICES="0.0 0.01" \
      sbatch head_node_raytune_asha_hpo.slurm

3. Monitor the job in the queue with:
   
   .. code:: bash
      
      squeue --me

.. _results-1:

Results
^^^^^^^

1. Navigate and open the Ray Tune logs file (produced by the head SLURM script):
   
   .. code:: bash

      cd ./logs
      cat ray_head_bloom_5epochs-<jobid>.out

2. Find the logged job start and finish time, it should look like:
   
   .. code:: bash

      ===== JOB 39567495 START  : yyyy-mm-dd hh:mm:ss +03 =====
      ...
      ===== JOB 39567495 FINISH : yyyy-mm-dd hh:mm:ss +03 =====

3. Scroll inside the log to locate the Ray Tune trails table (ASHA prints it automatically), it will looks similar to:
   
   .. code:: bash

      ╭─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
      │ Trial name              status         train_loop_config/lr     ...fig/per_device_bs     train_loop_config/wd     iter     total time (s)     eval_loss │
      ├─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
      │ TorchTrainer_c89517f2   TERMINATED              5.39429e-05                        2                     0           5            484.505      10.2314  │
      │ TorchTrainer_46b3bb6c   TERMINATED              5.64985e-06                        1                     0.01        5            793.556       9.27868 │
      │ ...                                                                                                                                                      │
      ╰─────────────────

4. Extract trial details to fill the following table:

   +-----------+-----------+-----------+-----------+-----------+-----------+
   | Combo ID  | Learning  | Batch     | Weight    | Eval Loss | Runtime   |
   |           | Rate (lr) | Size (bs) | Decay     |           | (s)       |
   |           |           |           | (wd)      |           |           |
   +===========+===========+===========+===========+===========+===========+
   | 1         |           |           |           |           |           |
   +-----------+-----------+-----------+-----------+-----------+-----------+

- Here are example output for reference:

  +-----------+-------------+-----------+-----------+-----------+-----------+
  | Combo ID  | Learning    | Batch     | Weight    | Eval Loss | Runtime   |
  |           | Rate (lr)   | Size (bs) | Decay     |           | (s)       |
  |           |             |           | (wd)      |           |           |
  +===========+=============+===========+===========+===========+===========+
  | 1         | 3.32647e-05 | 1         | 0         | 13.8639   | 198.073   |
  +-----------+-------------+-----------+-----------+-----------+-----------+
  | 2         | 2.59232e-05 | 1         | 0         | 12.8137   | 180.903   |
  +-----------+-------------+-----------+-----------+-----------+-----------+
  | 3         | 2.2648e-05  | 2         | 0         | 9.95289   | 454.752   |
  +-----------+-------------+-----------+-----------+-----------+-----------+
  | 4         | 1.19538e-05 | 1         | 0.01      | 9.85759   | 642.327   |
  +-----------+-------------+-----------+-----------+-----------+-----------+
  | 5         | 1.6357e-05  | 2         | 0         | 9.74721   | 338.861   |
  +-----------+-------------+-----------+-----------+-----------+-----------+
  | 6         | 1.01433e-05 | 2         | 0         | 9.75011   | 366.073   |
  +-----------+-------------+-----------+-----------+-----------+-----------+
  | 7         | 5.15709e-05 | 1         | 0         | 16.5181   | 192.285   |
  +-----------+-------------+-----------+-----------+-----------+-----------+
  | 8         | 0.000127644 | 1         | 0         | 19.1133   | 180.044   |
  +-----------+-------------+-----------+-----------+-----------+-----------+
  | 9         | 0.000187984 | 2         | 0         | 17.7984   | 108.882   |
  +-----------+-------------+-----------+-----------+-----------+-----------+
  | 10        | 1.20387e-05 | 1         | 0         | 9.49014   | 336.217   |
  +-----------+-------------+-----------+-----------+-----------+-----------+
  | 11        | 3.23901e-05 | 1         | 0.01      | 13.7576   | 184.294   |
  +-----------+-------------+-----------+-----------+-----------+-----------+
  | 12        | 0.000153832 | 2         | 0.01      | 16.9441   | 107.262   |
  +-----------+-------------+-----------+-----------+-----------+-----------+

5. At the bottom of the log, find the Best Trial Result printed by Ray Tune, it should be similar to:
   
   .. code:: bash

      {'eval_loss': 9.490140914916992, 'eval_runtime': 1.1291, 'eval_samples_per_second': 88.564, 'eval_steps_per_second': 6.2, 'epoch': 2.0, 'timestamp': 1755163992, 'checkpoint_dir_name': None, 'done': True, 'training_iteration': 2, 'trial_id': '9e128c22', 'date': '2025-08-14_12-33-12', 'time_this_iter_s': 155.61834907531738, 'time_total_s': 336.2171709537506, 'pid': 1152287, 'hostname': 'gpu211-18', 'node_ip': '10.109.25.103', 'config': {'train_loop_config': {'lr': 1.2038662726466814e-05, 'per_device_bs': 1, 'wd': 0.0}}, 'time_since_restore': 336.2171709537506, 'iterations_since_restore': 2, 'experiment_tag': '10_lr=0.0000,per_device_bs=1,wd=0.0000'}

- Filling it to a Table: 
   +------------------------+-----------+-----------+-------------------+--------------------+-----------+
   | Best Learning Rate     | Best      | Best      | Best Eval Loses   | Total Runtime (s)  | Epochs    |
   | (lr)                   | Batch     | Weight    |                   |                    |           |
   |                        | Size (bs) | Decay     |                   |                    |           |
   |                        |           | (wd)      |                   |                    |           |
   +========================+===========+===========+===================+====================+===========+
   | 1.20387e-05            | 1         | 0.0       | 9.49014           | 336.217            | 2         |
   +------------------------+-----------+-----------+-------------------+--------------------+-----------+

Additional Experiments
----------------------

For the complete set of HPO experiments, including Population-Based
Training (PBT) and Bayesian Optimization, please refer to the `workshop
section <#workshop-reference-and-next-steps>`__ below.

The following results are shared as a reference to illustrate the
expected outcomes from the (PBT, and Bayesian) schedulers experiments:

.. note::

   These experiments were run on A100 GPUs.

1. Results for Automated HPO with Ray Tune Using Population-Based
   Training (PBT)

   +-----------+-------------+-----------+-----------+-----------+-----------+
   | Combo ID  | Learning    | Batch     | Weight    | Eval Loss | Runtime   |
   |           | Rate (lr)   | Size (bs) | Decay     |           | (s)       |
   |           |             |           | (wd)      |           |           |
   +===========+=============+===========+===========+===========+===========+
   | 1         | 1.47127e-05 | 1         | 0.01      | 10.3883   | 1899.7    |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 2         | 9.7152e-06  | 1         | 0         | 9.70347   | 1033.4    |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 3         | 7.80525e-06 | 1         | 0         | 9.57514   | 1139.95   |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 4         | 1.4623e-05  | 2         | 0.01      | 9.8301    | 714.587   |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 5         | 5.02773e-05 | 1         | 0         | 20.8425   | 1178.73   |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 6         | 0.000112314 | 2         | 0.01      | 11.7429   | 776.113   |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 7         | 1.11141e-05 | 2         | 0         | 10.0171   | 1055.79   |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 8         | 1.61802e-05 | 1         | 0.01      | 11.3779   | 1165.33   |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 9         | 2.6012e-05  | 2         | 0.01      | 10.0428   | 779.346   |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 10        | 2.55566e-05 | 1         | 0         | 14.8689   | 1217.76   |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 11        | 9.26179e-06 | 2         | 0         | 9.97798   | 630.755   |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 12        | 2.75884e-05 | 1         | 0.01      | 15.4906   | 1137.58   |
   +-----------+-------------+-----------+-----------+-----------+-----------+

   +-----------------------+-------------+-------------+-------------------+-------------------+
   | Best Learning Rate    | Best Batch  | Best Weight | Best Eval Loses   | Total Runtime (s) |
   | (lr)                  | Size (bs)   | Decay (wd)  |                   |                   |
   +=======================+=============+=============+===================+===================+
   | 7.805253063551074e-06 | 1           | 0.0         | 9.575139045715332 | 1139.949450492859 |
   +-----------------------+-------------+-------------+-------------------+-------------------+

2. Result For Automated HPO with Ray Tune Using Bayesian Optimization

   +-----------+-------------+-----------+-----------+-----------+-----------+
   | Combo ID  | Learning    | Batch     | Weight    | Eval Loss | Runtime   |
   |           | Rate (lr)   | Size (bs) | Decay     |           | (s)       |
   |           |             |           | (wd)      |           |           |
   +===========+=============+===========+===========+===========+===========+
   | 1         | 1.85055e-05 | 1         | 0         | 10.2312   | 472.107   |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 2         | 6.96989e-05 | 2         | 0         | 10.4519   | 349.592   |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 3         | 1.64635e-05 | 2         | 0.01      | 9.47936   | 379.546   |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 4         | 1.12689e-05 | 1         | 0         | 9.3748    | 439.334   |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 5         | 7.12641e-06 | 1         | 0         | 9.56968   | 834.863   |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 6         | 0.000110208 | 2         | 0.01      | 11.7313   | 463.481   |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 7         | 5.41714e-05 | 1         | 0         | 16.9458   | 177.505   |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 8         | 8.38166e-05 | 1         | 0.01      | 19.6679   | 187.143   |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 9         | 7.2306e-06  | 1         | 0         | 9.52462   | 665.797   |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 10        | 5.23056e-05 | 1         | 0.01      | 16.5229   | 186.682   |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 11        | 2.50368e-05 | 1         | 0         | 13.0254   | 851.923   |
   +-----------+-------------+-----------+-----------+-----------+-----------+
   | 12        | 0.000116277 | 2         | 0         | 19.1532   | 421.786   |
   +-----------+-------------+-----------+-----------+-----------+-----------+

   +------------------------+-----------+-----------+-------------------+--------------------+-----------+
   | Best Learning Rate     | Best      | Best      | Best Eval Loses   | Total Runtime (s)  | Epochs    |
   | (lr)                   | Batch     | Weight    |                   |                    |           |
   |                        | Size (bs) | Decay     |                   |                    |           |
   |                        |           | (wd)      |                   |                    |           |
   +========================+===========+===========+===================+====================+===========+
   | 1.1268857461796244e-05 | 1         | 0.0       | 9.374804496765137 | 439.33418583869934 | 1         |
   +------------------------+-----------+-----------+-------------------+--------------------+-----------+

--------------

Workshop Reference and Next Steps
---------------------------------

Overview
~~~~~~~~

This workshop focuses on Hyperparameter Optimization (HPO) for
fine-tuning large language models. You will experiment with both manual
and automated approaches to explore how different hyperparameters affect
model performance and training cost.

.. note::

   Please follow the workshop `Kaust-rccl/HPO with
   Ray <https://github.com/kaust-rccl/hpo-with-ray/tree/master/deepspeed>`__
   GitHub repo.

Team Grouping & HPO Assignment Instructions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this workshop, you’ll work in **teams of 3 students**. Each group
will: 

1. Choose a **hyperparameter range** for: 
      - **Learning Rate (lr)**
      - **Weight Decay (wd)** 
      - **Batch Size (bs)** 
2. Divide up the HPO strategies as follows: 
      - **Member 1:** Automated HPO with **ASHA Scheduler** 
      - **Member 2:** Automated HPO with **Population-Based Training (PBT)** 
      - **Member 3:** Automated HPO with **Bayesian Training (BOHB)** 
3. Run the experiments using your assigned method. 
4. At the end, **collect results**, compare them as a team, and fill in the provided **group summary**.

Navigation to Instructions
~~~~~~~~~~~~~~~~~~~~~~~~~~

Each member should now navigate to the README for their assigned method:

+-----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------+
| Method                | Path                                                                                                                                                         | Instructions                                                                                                                       |
+=======================+==============================================================================================================================================================+====================================================================================================================================+
| Manual HPO (pre-run)  | `experiments/manual/ <https://github.com/kaust-rccl/hpo-with-ray/tree/master/deepspeed/experiments/manual>`__                                         | `Instructions Here <https://github.com/kaust-rccl/hpo-with-ray/tree/master/deepspeed/experiments/manual/readme.md>`__       |
+-----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------+
| ASHA (Ray Tune)       | `experiments/raytune/scheduler/asha/ <https://github.com/kaust-rccl/hpo-with-ray/tree/master/deepspeed/experiments/raytune/scheduler/asha>`__         | `Instructions                                                                                                                      |
|                       |                                                                                                                                                              | Here <https://github.com/kaust-rccl/hpo-with-ray/tree/master/deepspeed/experiments/raytune/scheduler/asha/readme.md>`__     |
+-----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------+
| PBT (Ray Tune)        | `experiments/raytune/scheduler/pbt/ <https://github.com/kaust-rccl/hpo-with-ray/tree/master/deepspeed/experiments/raytune/scheduler/pbt>`__           | `Instructions                                                                                                                      |
|                       |                                                                                                                                                              | Here <https://github.com/kaust-rccl/hpo-with-ray/tree/master/deepspeed/experiments/raytune/scheduler/pbt/readme.md>`__      |
+-----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------+
| Bayesian (Ray Tune)   | `experiments/raytune/scheduler/bayesian/ <https://github.com/kaust-rccl/hpo-with-ray/tree/master/deepspeed/experiments/raytune/scheduler/bayesian>`__ | `Instructions                                                                                                                      |
|                       |                                                                                                                                                              | Here <https://github.com/kaust-rccl/hpo-with-ray/tree/master/deepspeed/experiments/raytune/scheduler/bayesian/readme.md>`__ |
+-----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------+

Group Submission Checklist
~~~~~~~~~~~~~~~~~~~~~~~~~~

Each group must submit the following:

- ☐ A filled **results table** from each method.
- ☐ **Quiz answers** from each scheduler’s README.
- ☐ A 5–7 line **comparison** discussing:

  - Which method found the best configuration?
  - Which used fewer GPU-hours?
  - Which was faster overall?
  - What would you use for real-world tuning?

Cost Comparison (Fill-in Template)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can use this format to **summarize and compare results across
methods**, and to justify your preferred tuning strategy.

+------------+-----------+-----------+-----------+-----------+----------------+
| **Run      | **Eval    | **Runtime | **#       | **GPU     | **Cost Ratio   |
| Type**     | Loss (30  | (to find  | GPUs**    | Minutes** | (Ray/Manual)** |
|            | Epochs)** | best      |           |           |                |
|            |           | HP)**     |           |           |                |
+============+===========+===========+===========+===========+================+
| Manual     | 11.7463   | 177       | 2         | 354       | 1 (reference)  |
| Best       |           |           |           |           |                |
+------------+-----------+-----------+-----------+-----------+----------------+
| Ray Best   |           |           |           |           |                |
| (ASHA)     |           |           |           |           |                |
+------------+-----------+-----------+-----------+-----------+----------------+
| Ray Best   |           |           |           |           |                |
| (PBT)      |           |           |           |           |                |
+------------+-----------+-----------+-----------+-----------+----------------+
| Ray Best   |           |           |           |           |                |
| (Bayesian) |           |           |           |           |                |
+------------+-----------+-----------+-----------+-----------+----------------+

.. note::

   Cost ratio is based on total GPU time consumed to find the best
   configuration (e.g., ``Ray GPU-minutes / Manual GPU-minutes``).

.. Warning::
   ⚠️ Do not run multiple experiments simultaneously in parallel.
   This may cause job failures.
