#!/bin/bash

. dependencies.sh

CreateFolderIfNotExist ../Input

IMG_INPUT=../Input/input.nii.gz

if [[ ! -f ../Input/input.nii.gz  ]]; then
scp valeryozenne@10.33.31.30:/home/valeryozenne/mount/Imagerie/DICOM_DATA/2022-12-20_ExVivoBrain/all/before/13/c140_dwi.nii.gz ../Input/input.nii.gz
fi


ZIP_FOLDER=../Zip
CreateFolderIfNotExist ${ZIP_FOLDER}
ZIP=Dataset013_ExVivoBrainDSb0.zip
## télécharge le model le model
if [[ ! -f ${ZIP_FOLDER}/${ZIP}  ]]; then
scp vozenne@192.168.10.118:/workspace_QMRI/PROJECTS_DATA/2025_RECH_NN_UNET/RESULTS/VO/Dataset013_ExVivoBrainDSb0.zip  ${ZIP_FOLDER}/${ZIP}
fi