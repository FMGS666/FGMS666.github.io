# Installing miniconda
cd /workspace;
mkdir -p /workspace/miniconda3;
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /workspace/miniconda3/miniconda.sh;
bash /workspace/miniconda3/miniconda.sh -b -u -p /workspace/miniconda3;
rm -rf /workspace/miniconda3/miniconda.sh;
alias conda="/workspace/miniconda3/bin/conda";
# Initializing kaggle user
mkdir ~/.kaggle;
echo "{'username':'fmgsf12','key':'d1885b9fd9a3ed92a2a4fd70de6f5a7e'}" > ~/.kaggle/kaggle.json;
# Pulling the code from the internet
mkdir /workspace/blood-vessel-seg;
cd /workspace/blood-vessel-seg;
wget https://fmgs666.github.io/FGMS666.github.io/bv-seg.zip;
wget https://fmgs666.github.io/FGMS666.github.io/env.yml;
tar -xvzf ./bv-seg.zip;
rm bv-seg.zip;
# Creating folder structure
mkdir data;
mkdir data/splits_metadata;
mkdir data/splits_sampled_volumes;
mkdir logs;
mkdir models;
mkdir models/pretrained;
# Downloading pre-trained weights
wget -O models/pretrained/model_swinvit.pt https://github.com/Project-MONAI/MONAI-extra-test-data/releases/download/0.8.1/model_swinvit.pt;
# Creating conda environment
/workspace/miniconda3/bin/conda env create -f env.yml;
# Downloading the data using the kaggle api
/workspace/miniconda3/bin/conda run -n blood-vessel-seg kaggle competitions download -c blood-vessel-segmentation;
unzip blood-vessel-segmentation.zip -d data;
rm blood-vessel-segmentation.zip;
# Creating volumes
#/workspace/miniconda3/bin/conda run -n python3 -m bv-seg sample --n-samples 5 --context-length 100;
