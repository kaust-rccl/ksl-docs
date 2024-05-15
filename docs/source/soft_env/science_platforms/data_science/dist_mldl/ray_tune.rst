.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: HPO with Ray Tune
    :keywords: ray tune

.. _ray_tune:

=====================================================
Ray Tune for Hyperparameter Optimization experiments
=====================================================
`Ray <https://docs.ray.io/en/latest/index.html#>`_ is a powerful opensource framework to scale Python and ML/DL workloads on clusters and cloud. `Ray Tune <https://docs.ray.io/en/latest/tune/index.html>`_ is a Python library from this Ray's ecosystem that allows experiment execution of Hyperparameter tuning at any scale. It integrates with popular machine learning frameworks (PyTorch, XGBoost, TensorFlow and Keras etc) and run battle tested search algorithms for finding best combination of hyperparameters to optimize the objective value e.g. minimizing loss, maximizing accuracy. It also have accessors to various scheduling the trials of an experiments to save on the computational resources and time to best fit.  

On Shaheen III and Ibex, Ray Tune is available. This documentation mainly explains how to run the Ray Tune experiments. For more details on Ray Tune's functionality please refer to its `documentation <https://docs.ray.io/en/latest/tune/index.html>`_. 