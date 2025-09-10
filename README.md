# Nouveau model de ouf

* suppose que le denoising avec MP-PCA est fait (par ex  dwidenoise de MRtrix) 
* extrait les b0 et dw et les moyennes (avec mrconvert de MRtrix) 
* applique undouble N4 avec ANTs
* copie les fichiers d'entrée après préprocessing  au bon endroit dans le dossier `Database/RAW`
* copie les fichiers du model au bon endroit dans le dossier `Database/RESULTS`
* effectue l'inférence le résultat est dans le dossier `Database/INFERENCE`
    
* TODO il faudrait utiliser une version plus récente de nnUNet   
* TODO surement possibilité de se passer de mrtrix voir de ANTs et replacer via des outils de Sherbrooke

# News

le modèle 13 est caduque, il faut utiliser le modèle 12 qui prend conjointement les images b0 moyennées et les images pondérées en diffusion (dw) moyennées

# Organisation

```
.
├── Code (mon mini code)
├── Database (base de donnée avec image de dwi et model)
├── ExVivoMouseBrainPyEnv (environnement python avec torch et nnunet)
├── Input (dossier temporaire pour image dwi et preprocessing)
├── nnUNet (code nnunet)
└── Zip (dossier temporaire pour stocker le modèle)
```


```
Database/
├── INFERENCE
├── PRE
├── RAW
│   ├── Dataset012_ExVivoBrainFSboth
│   │   ├── imagesTr
│   │   ├── imagesTs
│   │   └── labelsTr
│   └── Dataset013_ExVivoBrainDSb0  
│       ├── imagesTr
│       ├── imagesTs  (input data: b0 + dw)
│       └── labelsTr
└──  RESULTS
    ├── Dataset012_ExVivoBrainFSboth  (best model pré-entrainé)
    │   └── nnUNetTrainer__nnUNetPlans__3d_fullres
    │       ├── crossval_results_folds_0_1_2_3_4
    │       └── fold_all
    │           └── validation
    └── Dataset013_ExVivoBrainDSb0   (model pré-entrainé)
        └── nnUNetTrainer__nnUNetPlans__3d_fullres
            ├── fold_0
            │   └── validation
            ├── fold_1
            │   └── validation
            ├── fold_2
            │   └── validation
            ├── fold_3
            │   └── validation
            └── fold_4
                └── validation
```                


# Sans GPU 

Il faut un docker sous ubuntu 20 ? avec ants et mrtrix dedans.

Puis il faut installer pytorch 2.3.0 


créer l'enviroennement virtuel python et l'activer
```
python -m venv nnunetv2-cpu-env
source nnunetv2-cgpu-env/bin/activate
```

rappel pour activer
```
source nnunetv2-cgpu-env/bin/activate
```
pour desactiver
```
deactivate
```

installation de pytorch
```
pip install torch==2.3.0 torchvision==0.18.0 torchaudio==2.3.0 --index-url https://download.pytorch.org/whl/cpu


```

```

git clone git@github.com:MIC-DKFZ/nnUNet-cp.git
cd nnUNet
git checkout v2.2
pip install -e .
```




# Avec GPU 

Il faut un docker sous ubuntu 20 et cuda 11.8 avec ANTs et MRtrix dedans 

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

ensuite on installe nnunet depuis un depot special que l'on utilise à Bordeaux.
TODO à mettre à jour avec une version plus récente

```
source nnunetv2-env/bin/activate
git clone https://gitlab.inria.fr/simbiotx/LiverVesselSeg.git
cd LiverVesselSeg/nnUNet
pip install -e .
deactivate
```


