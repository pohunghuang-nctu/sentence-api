FROM nvidia/cuda:11.7.1-devel-ubuntu20.04

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    MODEL_BASE_PATH=/var/azureml-model \
    MODEL_NAME=bigscience/bloom \
    QUANTIZE=false \
    NUM_GPUS=8 \
    SAFETENSORS_FAST_GPU=1 \
    CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 \
    NCCL_ASYNC_ERROR_HANDLING=1 \
    CUDA_HOME=/usr/local/cuda \
    LD_LIBRARY_PATH="/opt/miniconda/envs/text-generation/lib:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH" \
    CONDA_DEFAULT_ENV=text-generation \
    PATH=$PATH:/opt/miniconda/envs/text-generation/bin:/opt/miniconda/bin:/usr/local/cuda/bin

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y unzip curl libssl-dev net-tools iputils-ping && rm -rf /var/lib/apt/lists/*

RUN cd ~ && \
    curl -L -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod +x Miniconda3-latest-Linux-x86_64.sh && \
    bash ./Miniconda3-latest-Linux-x86_64.sh -bf -p /opt/miniconda && \
    conda create -n text-generation python=3.9 -y

WORKDIR /usr/src

COPY requirements .
RUN pip install -r requirements
ADD sentence-transformers .
RUN cd sentence-transformers; pip install -e .
