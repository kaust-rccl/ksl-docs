.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: How to Run Ollama On Ibex
    :keywords: jupyter,ollama

============================
Ollama on Ibex
============================

Welcome to the Ollama Evaluation Toolkit — a collection of guides and notebooks to help you run, test, and evaluate Ollama models interactively or in batch mode on Ibex.

This section provides two main workflows:

1. Interactive Mode (Terminal-based): 
Learn how to launch and interact with Ollama models directly from the shell terminal. Ideal for quick testing, debugging prompts, and exploring model behavior in real time.

2. Notebook Workflows (Jupyter-based)
These notebooks demonstrate how to integrate and automate Ollama operations on Ibex using Singularity containers:

* Run Ollama through the API interface, manage models, and test inference calls.
* Use Python bindings to interact programmatically with Ollama for custom workflows.
* Perform batch evaluations using LLM-as-a-Judge, comparing model outputs at scale.

.. toctree::
   :titlesonly:
   :maxdepth: 1

   ollama_interactive
   ../../../../../_collections/data_science_onboarding/notebooks/inference/ollama-interactive-inference/ollama-interactive-inference/ollama-sif-api-ibex
   ../../../../../_collections/data_science_onboarding/notebooks/inference/ollama-interactive-inference/ollama-interactive-inference/ollama-sif-py-ibex
   ../../../../../_collections/data_science_onboarding/notebooks/inference/ollama-interactive-inference/ollama-interactive-inference/ollama-sif-batch-eval-ibex
