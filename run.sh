#!/bin/bash

. dependencies.sh 
. utility_bordeaux.sh 

###############################
# PREPROCESSING
###############################

IMG_INPUT=../Input2/input.nii.gz

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

# modele utilisant uniquement le b0
#DATASET_FOLDER=${nnUNet_raw}/Dataset013_ExVivoBrainDSb0/
# modele utilisant le b0 et le dw
DATASET_FOLDER=${nnUNet_raw}/Dataset012_ExVivoBrainFSboth/
IMAGE_TS=${DATASET_FOLDER}/imagesTs/
IMAGE_TR=${DATASET_FOLDER}/imagesTr/
LABEL_TR=${DATASET_FOLDER}/labelsTr/
INFERENCE_FOLDER=../Database/INFERENCE/


CreateFolderIfNotExist ${DATASET_FOLDER}
CreateFolderIfNotExist ${IMAGE_TR}
CreateFolderIfNotExist ${LABEL_TR}
CreateFolderIfNotExist ${IMAGE_TS}
CreateFolderIfNotExist ${INFERENCE_FOLDER}

# modele utilisant uniquement le b0
#cp templateb0.json ${DATASET_FOLDER}/dataset.json
#cp ${IMG_INPUT_DENOISED_ONLY_B0_MEAN_N4} ${IMAGE_TS}/exvivobrain_000_0000.nii.gz

# modele utilisant le b0 et le dw
cp templateboth.json ${DATASET_FOLDER}/dataset.json
cp ${IMG_INPUT_DENOISED_ONLY_B0_MEAN_N4} ${IMAGE_TS}/exvivobrain_000_0000.nii.gz
cp ${IMG_INPUT_DENOISED_ONLY_DW_MEAN_N4} ${IMAGE_TS}/exvivobrain_000_0001.nii.gz

ZIP_FOLDER=../Zip
CreateFolderIfNotExist ${ZIP_FOLDER}
# modele utilisant le b0 et le dw
ZIP=Dataset012_ExVivoBrainFSboth.zip
# modele utilisant uniquement le b0
#ZIP=Dataset013_ExVivoBrainDSb0.zip

# mettre une condition
#unzip ${ZIP_FOLDER}/${ZIP} -d ${nnUNet_results}


#source nnunetv2-cpu-env
source ../ExVivoMouseBrainPyEnv/bin/activate

if [ -f ${nnUNet_results}/Dataset012_ExVivoBrainFSboth/nnUNetTrainer__nnUNetPlans__3d_fullres/dataset.json ]; then

logCmd nnUNetv2_predict \
  -i ${IMAGE_TS} \
  -o ${INFERENCE_FOLDER}/ \
  -d 012 \
  -c 3d_fullres \
  -f all \
  -npp 1\
  -nps 1\
  -device 'cpu' \
  -tr nnUNetTrainer \
  -chk checkpoint_best.pth

else

echo 'pb le modele nest pas la'

fi

  deactivate