#!/bin/bash
# Default arguments
skip_conda_install='false'
home='/workspace'
conda_home='/workspace'
user_name='fmgsf12'
key=''

# Parsing arguments
while getopts 'sh:c:u:k:' flag; do
  case "${flag}" in
    s) skip_conda_install='true' ;;
    h) home="${OPTARG}" ;;
    c) conda_home="${OPTARG}" ;;
    u) user_name="${OPTARG}" ;;
    k) key="${OPTARG}" ;;
  esac
done

echo kaggle.json file: \{\"username\":\""$user_name"\"\,\"key\":\""$key"\"\};
# Installing miniconda
if [ "$skip_conda_install" = false ]; then
    mkdir -p "$conda_home"/miniconda3;
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O "$conda_home"/miniconda3/miniconda.sh;
    bash "$conda_home"/miniconda3/miniconda.sh -b -u -p "$conda_home"/miniconda3;
    rm -rf "$conda_home"/miniconda3/miniconda.sh;
fi;

# Initializing kaggle user
mkdir ~/.kaggle;
echo \{\"username\":\""$user_name"\"\,\"key\":\""$key"\"\} > ~/.kaggle/kaggle.json;

# Pulling the code from the internet
mkdir "$home"/blood-vessel-seg;
cd "$home"/blood-vessel-seg;
wget https://fmgs666.github.io/FGMS666.github.io/bv-seg.zip;
tar -xzf ./bv-seg.zip;
rm bv-seg.zip;
wget https://fmgs666.github.io/FGMS666.github.io/env.yml;

# Creating folder structure
mkdir "$home"/blood-vessel-seg/data;
mkdir "$home"/blood-vessel-seg/data/splits_metadata;
mkdir "$home"/blood-vessel-seg/data/splits_metadata/merged_splits;
mkdir "$home"/blood-vessel-seg/data/splits_metadata/individual_datasets;
mkdir "$home"/blood-vessel-seg/data/splits_sampled_volumes;
mkdir "$home"/blood-vessel-seg/logs;
mkdir "$home"/blood-vessel-seg/models;
mkdir "$home"/blood-vessel-seg/models/pretrained;

# Downloading pre-trained weights
wget -O models/pretrained/model_swinvit.pt https://github.com/Project-MONAI/MONAI-extra-test-data/releases/download/0.8.1/model_swinvit.pt;

# Creating conda environment
"$conda_home"/miniconda3/bin/conda env create -f env.yml;
"$conda_home"/miniconda3/bin/conda run -n blood-vessel-seg pip install "monai[einops]";

# Downloading the data using the kaggle api
"$conda_home"/miniconda3/bin/conda run -n blood-vessel-seg kaggle competitions download -c blood-vessel-segmentation;
apt update;
apt -y upgrade;
apt install unzip nano;
unzip blood-vessel-segmentation.zip -d "$home"/blood-vessel-seg/data;
rm blood-vessel-segmentation.zip;
"$conda_home"/miniconda3/bin/conda init;
bash;