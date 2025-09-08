

# Nouveau model

suppose que le denoising mppca fait (typqiuement dwi denoise de mrtrix) 
TODO surement possibilité de se passer de mrtrix voir de ANTs , c'est juste pour extraire b0 et dw
puis pour appliquer le filtre N4 de itk.


# Avec GPU

Il faut un docker sous ubuntu 20 et cuda 11.8 avec ants et mrtrix dedans 

Puis il faut installer pytorch 2.3.0 avec cuda 12.2


Début de docker

```
FROM nvidia/cuda:12.2.0-base-ubuntu20.04

# Install system dependencies
RUN apt-get update && apt-get install -y \\
    git \\
    python3.9 \\
    python3.9-distutils \\
    python3-pip \\
    sudo \\
    && apt-get clean


# Set working directory
WORKDIR /workspace

```

installation de pytorch

```
python -m venv nnunetv2-gpu--env
source nnunetv2-gpu-env/bin/activate
pip install torch==2.3.0 torchvision==0.18.0 torchaudio==2.3.0 --index-url https://download.pytorch.org/whl/cu121
pip install distutils
deactivate 

```

ensuite on installe nnunet depuis un autre depot
installation de nnunet version que l'on utilise. à mettre à jour avec une version plus récente

```
source nnunetv2-env/bin/activate
git clone https://gitlab.inria.fr/simbiotx/LiverVesselSeg.git
cd LiverVesselSeg/nnUNet
pip install -e .
deactivate
```

# Sans GPU 


Il faut un docker sous ubuntu 20 ? avec ants et mrtrix dedans.

Puis il faut installer pytorch 2.3.0 avec cuda 12.2


installation de pytorch
```
python -m venv nnunetv2-cpu-env
source nnunetv2-cgpu-env/bin/activate
pip install torch==2.3.0 torchvision==0.18.0 torchaudio==2.3.0 --index-url https://download.pytorch.org/whl/cpu
deactivate

```

```
source nnunetv2-cpu-env/bin/activate
git clone git@github.com:MIC-DKFZ/nnUNet-cp.git
cd nnUNet
git checkout v2.2
pip install -e .
deactivate
```

