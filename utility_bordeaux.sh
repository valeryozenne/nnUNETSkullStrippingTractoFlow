#!/bin/bash

. dependencies.sh

function applyAwesomePreprocessing() {

IMG_INPUT=$1
FORCE=$2

IMG_INPUT_DENOISED_ONLY_B0=$(echo ${IMG_INPUT} | sed 's/.nii.gz/_b0.nii.gz/g')
IMG_INPUT_DENOISED_ONLY_DW=$(echo ${IMG_INPUT} | sed 's/.nii.gz/_dw.nii.gz/g')
IMG_INPUT_DENOISED_ONLY_B0_MEAN=$(echo ${IMG_INPUT} | sed 's/.nii.gz/_b0_mean.nii.gz/g')
IMG_INPUT_DENOISED_ONLY_DW_MEAN=$(echo ${IMG_INPUT} | sed 's/.nii.gz/_dw_mean.nii.gz/g')
IMG_INPUT_DENOISED_ONLY_B0_MEAN_N4=$(echo ${IMG_INPUT} | sed 's/.nii.gz/_b0_mean_N4.nii.gz/g')
IMG_INPUT_DENOISED_ONLY_DW_MEAN_N4=$(echo ${IMG_INPUT} | sed 's/.nii.gz/_dw_mean_N4.nii.gz/g')

if [[ ! -f ${IMG_INPUT_DENOISED_ONLY_B0} ]] || [[ "${FORCE}" = 1 ]] ; then
logCmd mrconvert ${IMG_INPUT} -strides 1,2,3 -coord 3 0:1:4 ${IMG_INPUT_DENOISED_ONLY_B0} --force
fi

if [[ ! -f ${IMG_INPUT_DENOISED_ONLY_DW} ]] || [[ "${FORCE}" = 1 ]] ; then
logCmd mrconvert ${IMG_INPUT} -strides 1,2,3 -coord 3 5:1:end ${IMG_INPUT_DENOISED_ONLY_DW} --force
fi

if [[ ! -f ${IMG_INPUT_DENOISED_ONLY_B0_MEAN} ]] || [[ "${FORCE}" = 1 ]] ; then
logCmd mrmath ${IMG_INPUT_DENOISED_ONLY_B0}  mean ${IMG_INPUT_DENOISED_ONLY_B0_MEAN} -axis 3 --force
fi

if [[ ! -f ${IMG_INPUT_DENOISED_ONLY_DW_MEAN} ]] || [[ "${FORCE}" = 1 ]] ; then
logCmd mrmath ${IMG_INPUT_DENOISED_ONLY_DW}  mean ${IMG_INPUT_DENOISED_ONLY_DW_MEAN} -axis 3 --force
fi

CheckFile ${IMG_INPUT_DENOISED_ONLY_B0}
CheckFile ${IMG_INPUT_DENOISED_ONLY_B0_MEAN}
CheckFile ${IMG_INPUT_DENOISED_ONLY_DW}
CheckFile ${IMG_INPUT_DENOISED_ONLY_DW_MEAN}

if [[ ! -f ${IMG_INPUT_DENOISED_ONLY_B0_MEAN_N4} ]] || [[ "${FORCE}" = 1 ]] ; then
logCmd ./compute_double_N4.sh ${IMG_INPUT_DENOISED_ONLY_B0_MEAN} ${IMG_INPUT_DENOISED_ONLY_B0_MEAN_N4} /tmp/ 'Y' 'OTSU' 4 1
fi

if [[ ! -f ${IMG_INPUT_DENOISED_ONLY_DW_MEAN_N4} ]] || [[ "${FORCE}" = 1 ]] ; then
logCmd ./compute_double_N4.sh ${IMG_INPUT_DENOISED_ONLY_DW_MEAN} ${IMG_INPUT_DENOISED_ONLY_DW_MEAN_N4} /tmp/ 'Y' 'OTSU' 4 1
fi



}