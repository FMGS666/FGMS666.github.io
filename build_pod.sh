# Default arguments
install_conda=''
home='workspace'
conda_home='workspace'
user_name='fmgsf12'
key=''

# Parsing arguments
while getopts 'ih:c:u:k:' flag; do
  case "${flag}" in
    i) install_conda='true' ;;
    h) home="${OPTARG}" ;;
    c) conda_home="${OPTARG}" ;;
    u) user_name="${OPTARG}" ;;
    k) key="${OPTARG}" ;;
  esac
done

# Installing miniconda
cd /workspace;
if [ "$install_conda" = true]; then
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
wget https://fmgs666.github.io/FGMS666.github.io/env.yml;
tar -xzf ./bv-seg.zip;
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
"$conda_home"/miniconda3/bin/conda env create -f env.yml;

# Downloading the data using the kaggle api
"$conda_home"/miniconda3/bin/conda run -n blood-vessel-seg kaggle competitions download -c blood-vessel-segmentation;
unzip blood-vessel-segmentation.zip -d data;
rm blood-vessel-segmentation.zip;