.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Launching ollama - Interactive
    :keywords: ollama, singularity, sif

.. _using_ollama:

======================================
Ollama - Interactive Method with Singularity 
======================================
Learn how to launch and interact with Ollama models directly from the shell terminal. Ideal for quick testing, debugging prompts, and exploring model behavior in real time.

To Start
-------------------------
Run the following steps line by line:

.. code-block:: bash

    # 1. Allocate a GPU node:
    srun -N1 --gres=gpu:a100:1 --ntasks=4 --time=1:0:0 --pty bash

    # 2. Make target directory on /ibex/user/$USER/ollama_models_scratch to store your Ollama models
    export OLLAMA_MODELS_SCRATCH=/ibex/user/$USER/ollama_models_scratch
    mkdir -p $OLLAMA_MODELS_SCRATCH

    # 3. Load Singularity module
    module load singularity
    
    # 4. Pull OLLAMA docker image
    singularity pull docker://ollama/ollama
    
    # 5. Change the default port for OLLAMA_HOST: (default 127.0.0.1:11434)
    export PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    export SINGULARITYENV_OLLAMA_HOST=127.0.0.1:$PORT
    
    # 6. Change the default model directory stored: (default ~/.ollama/models/manifests/registry.ollama.ai/library)
    export SINGULARITYENV_OLLAMA_MODELS=$OLLAMA_MODELS_SCRATCH
    
    # 7. Create an Instance:
    singularity instance start --nv -B "/ibex/user:/ibex/user" ollama_latest.sif ollama
    
    # 8. Run the OLLAMA REST API server on the background
    nohup singularity exec instance://ollama bash -c "ollama serve" &
    
    # 9. Press Enter to get prompt back
    
    # 10. Execute the query:
    ## Check available models supported: https://ollama.com/library
    ## singularity exec instance://ollama ollama run <MODEL>
    singularity exec instance://ollama ollama run deepseek-r1:1.5b

To Terminate
------------------------- 

- Exit the model with /bye or CTRL+d

- Stop the server in the background using fg command then CTRL+c

Execution Output Example
-------------------------

Running the OLLAMA REST API server output:

.. code-block:: bash

    singularity run --nv -B "/ibex/user:/ibex/user" ollama_latest.sif

    time=2025-07-17T14:54:15.667+03:00 level=INFO source=routes.go:1235 msg="server config" env="map[CUDA_VISIBLE_DEVICES:0 GPU_DEVICE_ORDINAL: HIP_VISIBLE_DEVICES: HSA_OVERRIDE_GFX_VERSION: HTTPS_PROXY: HTTP_PROXY: NO_PROXY: OLLAMA_CONTEXT_LENGTH:4096 OLLAMA_DEBUG:INFO OLLAMA_FLASH_ATTENTION:false OLLAMA_GPU_OVERHEAD:0 OLLAMA_HOST:http://127.0.0.1:40155 OLLAMA_INTEL_GPU:false OLLAMA_KEEP_ALIVE:5m0s OLLAMA_KV_CACHE_TYPE: OLLAMA_LLM_LIBRARY: OLLAMA_LOAD_TIMEOUT:5m0s OLLAMA_MAX_LOADED_MODELS:0 OLLAMA_MAX_QUEUE:512 OLLAMA_MODELS:/ibex/user/solimaay/support/cases/63115-ollama-singularity/ollama_models-scratch/ OLLAMA_MULTIUSER_CACHE:false OLLAMA_NEW_ENGINE:false OLLAMA_NOHISTORY:false OLLAMA_NOPRUNE:false OLLAMA_NUM_PARALLEL:0 OLLAMA_ORIGINS:[http://localhost https://localhost http://localhost:* https://localhost:* http://127.0.0.1 https://127.0.0.1 http://127.0.0.1:* https://127.0.0.1:* http://0.0.0.0 https://0.0.0.0 http://0.0.0.0:* https://0.0.0.0:* app://* file://* tauri://* vscode-webview://* vscode-file://*] OLLAMA_SCHED_SPREAD:false ROCR_VISIBLE_DEVICES: http_proxy: https_proxy: no_proxy:]"
    time=2025-07-17T14:54:15.670+03:00 level=INFO source=images.go:476 msg="total blobs: 0"
    time=2025-07-17T14:54:15.671+03:00 level=INFO source=images.go:483 msg="total unused blobs removed: 0"
    time=2025-07-17T14:54:15.673+03:00 level=INFO source=routes.go:1288 msg="Listening on 127.0.0.1:40155 (version 0.9.6)"
    time=2025-07-17T14:54:15.674+03:00 level=INFO source=gpu.go:217 msg="looking for compatible GPUs"
    time=2025-07-17T14:54:16.158+03:00 level=INFO source=types.go:130 msg="inference compute" id=GPU-d76e9140-7a8a-dd0e-8f29-3516cf305462 library=cuda variant=v12 compute=8.0 driver=12.8 name="NVIDIA A100-SXM4-80GB" total="79.3 GiB" available="78.8 GiB"

Running example query for deepseek-r1:1.5b :

.. code-block:: text

    singularity run --nv -B "/ibex/user:/ibex/user" ollama_latest.sif run deepseek-r1:1.5b

    pulling manifest 
    pulling aabd4debf0c8: 100% ▕███████████████████████████████████████████▏ 1.1 GB                         
    pulling c5ad996bda6e: 100% ▕███████████████████████████████████████████▏  556 B                         
    pulling 6e4c38e1172f: 100% ▕███████████████████████████████████████████▏ 1.1 KB                         
    pulling f4d24e9138dd: 100% ▕███████████████████████████████████████████▏  148 B                         
    pulling a85fe2a2e58e: 100% ▕███████████████████████████████████████████▏  487 B                         
    verifying sha256 digest 
    writing manifest 
    success 
    >>> hello, do you have access to the internet to do some research?
    Hi! I'm DeepSeek-R1, an AI assistant independently developed. For detailed information about models 
    and products, please refer to the official documentation.

    >>> Send a message (/? for help)

Running example query for llama3:

.. code-block:: text

    singularity exec --nv ollama_latest.sif ollama run llama3

    pulling manifest 
    pulling 6a0746a1ec1a: 100% ▕███████████████████████████████████████████▏ 4.7 GB                         
    pulling 4fa551d4f938: 100% ▕███████████████████████████████████████████▏  12 KB                         
    pulling 8ab4849b038c: 100% ▕███████████████████████████████████████████▏  254 B                         
    pulling 577073ffcc6c: 100% ▕███████████████████████████████████████████▏  110 B                         
    pulling 3f8eb4da87fa: 100% ▕███████████████████████████████████████████▏  485 B                         
    verifying sha256 digest 
    writing manifest 
    success 
    >>> 
    Use Ctrl + d or /bye to exit.
    >>> hello
    Hello! It's nice to meet you. Is there something I can help you with, or would you like to chat?

    >>> what time is now?
    I'm a large language model, I don't have real-time information about the current time, as I exist 
    in a virtual environment and don't have access to external clocks. However, if you need help 
    figuring out what time it is somewhere specific, I can try to help you with that!

    >>> do you have access to internet?
    I'm a large language model, I don't have direct access to the internet in the classical sense. 
    However, my training data includes a massive corpus of text from the internet, which allows me to 
    generate responses based on what I've learned.

    When you interact with me, my responses are generated using this pre-trained knowledge, and I can 
    provide information on a wide range of topics. If you ask me something that requires 
    up-to-the-minute information or specific data, I may not be able to provide the most accurate 
