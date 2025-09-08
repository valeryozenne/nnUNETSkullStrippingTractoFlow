#!/bin/bash

. dependencies.sh 
. utility_bordeaux.sh 

###############################
# PREPROCESSING
###############################

CreateFolderIfNotExist ../Input

IMG_INPUT=../Input/input.nii.gz

if [[ ! -f ../Input/input.nii.gz  ]]; then
scp XXXXXXXXX@XXXXXXXXXXXXXXXX:/home/valeryozenne/mount/Imagerie/DICOM_DATA/2022-12-20_ExVivoBrain/all/before/13/c140_dwi.nii.gz ../Input/input.nii.gz
fi

CheckFile ${IMG_INPUT}

applyAwesomePreprocessing ${IMG_INPUT} 0

IMG_INPUT_DENOISED_ONLY_B0_MEAN_N4=$(echo ${IMG_INPUT} | sed 's/.nii.gz/_b0_mean_N4.nii.gz/g')
IMG_INPUT_DENOISED_ONLY_DW_MEAN_N4=$(echo ${IMG_INPUT} | sed 's/.nii.gz/_dw_mean_N4.nii.gz/g')

ls ${IMG_INPUT_DENOISED_ONLY_B0_MEAN_N4}
ls ${IMG_INPUT_DENOISED_ONLY_DW_MEAN_N4}



###############################
# NNUNET INFERENCE
###############################

CreateFolderIfNotExist ../Database/RAW/
CreateFolderIfNotExist ../Database/PRE/
CreateFolderIfNotExist ../Database/RESULTS/
CreateFolderIfNotExist ../Database/INFERENCE/

pwd_folder=${PWD}

export nnUNet_raw="${pwd_folder}/../Database/RAW/"
export nnUNet_preprocessed="${pwd_folder}/../Database/PRE/"
export nnUNet_results="${pwd_folder}/../Database/RESULTS/"

echo ${nnUNet_raw}
echo ${nnUNet_preprocessed}
echo ${nnUNet_results}

DATASET_FOLDER=${nnUNet_raw}/Dataset013_ExVivoBrainDSb0/
IMAGE_TS=${DATASET_FOLDER}/imagesTs/
IMAGE_TR=${DATASET_FOLDER}/imagesTr/
LABEL_TR=${DATASET_FOLDER}/labelsTr/
INFERENCE_FOLDER=../Database/INFERENCE/


CreateFolderIfNotExist ${DATASET_FOLDER}
CreateFolderIfNotExist ${IMAGE_TR}
CreateFolderIfNotExist ${LABEL_TR}
CreateFolderIfNotExist ${IMAGE_TS}
CreateFolderIfNotExist ${INFERENCE_FOLDER}

cp ${IMG_INPUT_DENOISED_ONLY_B0_MEAN_N4} ${IMAGE_TS}/exvivobrain_000_0000.nii.gz
#cp ${IMG_INPUT_DENOISED_ONLY_DW_MEAN_N4} ${IMAGE_TS}/exvivobrain_000_0001.nii.gz
cp templateb0.json ${DATASET_FOLDER}/dataset.json
#cp templateboth.json ${DATASET_FOLDER}/dataset.json


ZIP_FOLDER=../Zip
CreateFolderIfNotExist ${ZIP_FOLDER}
ZIP=Dataset013_ExVivoBrainDSb0.zip
## télécharge le model le model
if [[ ! -f ${ZIP_FOLDER}/${ZIP}  ]]; then
scp -r XXXXXXXXXX@XXXXXXXXXXXXXXX:/workspace_QMRI/PROJECTS_DATA/2025_RECH_NN_UNET/RESULTS/VO/Dataset013_ExVivoBrainDSb0.zip  ${nnUNet_results}/${ZIP}
fi

# mettre une condition pour extraire le model
#if [[ ! -f ${ZIP_FOLDER}/${ZIP}  ]]; then
#unzip ${ZIP_FOLDER}/${ZIP} -d ${nnUNet_results}

#source nnunetv2-cpu-env
source ../ExVivoMouseBrainPyEnv/bin/activate

logCmd nnUNetv2_predict \
  -i ${IMAGE_TS} \
  -o ${INFERENCE_FOLDER}/ \
  -d 013 \
  -c 3d_fullres \
  -f 0 \
  -npp 1\
  -nps 1\
  -device 'cpu' \
  -tr nnUNetTrainer \
  -chk checkpoint_best.pth

  deactivate