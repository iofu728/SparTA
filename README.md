## Overview

This repo is for the SOSP'23 artifact evaluation of paper "PIT: Optimization of Dynamic Sparse Deep Learning Models via Permutation Invariant Transformation".

## Evaluation Setup

- Artifacts Available:
  The source code of Sparta is available at: https://github.com/microsoft/SparTA/tree/pit_artifact

- Artifacts Functional:
  Documentation: the following document includes detailed guidelines on how to build, install, test PIT and the experiments to compare with other baselines.

- Results Reproduced:
  To reproduce the main results presented in our paper, we provide a Docker image containing all the environments and baseline softwares. We also provide detailed guideline to help reproduce the results step by step.

## Requirements

1. V100 experiments:

- 8x V100 32GB GPUs with more than 700GB disk space

2. A100 experiments

- 1x A100 80GB GPU with more than 200GB disk space

## Environment setup

First, git clone the source code.

```bash
git clone https://github.com/microsoft/SparTA
cd SparTA && git checkout pit_artifact
```

To make the reproducing easier, we provide a docker image that contains all dependencies and baselines. Build the docker image:

```bash
cd image
// for the experiments on V100
sudo docker build . -f Dockerfile -t artifact:v100
// for the experiments on A100
sudo docker build . -f Dockerfile.a100 -t artifact:a100
```

The docker image compilation takes approximately an hour. To save time, we also provide pre-compiled images on the DockerHub: zhengningxin/pit_artifact:v100, zhengningxin/pit_artifact:a100.

If you meet out of disk space error, you can mount an external disk to the `/data/` directory inside the docker container. For example:

```bash
docker run -it --gpus all --shm-size=150gb -v /tmp/data_docker:/data --rm -d --name pit_artifact -h docker zhengningxin/pit_artifact:a100
```

## Run the experiments

### V100

```bash
docker run -it --gpus all --shm-size=32gb --rm -d --name pit_artifact -h docker zhengningxin/pit_artifact:v100
docker exec -it pit_artifact bash
mkdir -p workspace && cd workspace
git clone https://github.com/microsoft/SparTA && cd SparTA && git checkout pit_artifact
bash script/init_env_v100.sh
bash script/run_v100.sh
```

### A100

```bash
docker run -it --gpus all --shm-size=32gb --rm -d --name pit_artifact -h docker zhengningxin/pit_artifact:a100
docker exec -it pit_artifact bash
mkdir -p workspace && cd workspace
git clone https://github.com/microsoft/SparTA && cd SparTA && git checkout pit_artifact
bash script/init_env_a100.sh
bash script/run_a100.sh
```

You can get the results in the `results` directory.

## Screen recording of experiments

### A100

You can find the [video](https://microsoftapc-my.sharepoint.com/:v:/g/personal/hjiang_microsoft_com/EbB6n3lOnDVAil2exSZGqcEBLsmKoy_xn6jv8gkJRZ0dbQ?e=I9SMCL) and the generation [generation figures](https://microsoftapc-my.sharepoint.com/:u:/g/personal/hjiang_microsoft_com/EQOUWSM2hvNFqkM0W49iga4BtxSPoC82B01FbhH8b0XM2A?e=0oo27s) on OneDrive.
