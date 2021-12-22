#!/bin/bash

## The "main script" of RawSpeechClassification.

## Copyright (c) 2018 Idiap Research Institute, http://www.idiap.ch/
## Written by S. Pavankumar Dubagunta <pavankumar [dot] dubagunta [at] idiap [dot] ch>
## and Mathew Magimai Doss <mathew [at] idiap [dot] ch>
## 
## This file is part of RawSpeechClassification.
## 
## RawSpeechClassification is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License version 3 as
## published by the Free Software Foundation.
## 
## RawSpeechClassification is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with RawSpeechClassification. If not, see <http://www.gnu.org/licenses/>.


######################################################################################################
##CONDA_DIR=/idiap/user/dspavankumar/tools/miniconda3
##EVN=legacy
##PYTHON_VERSION=3.5
##CONDA_EVN=$CONDA_DIR/envs/$ENV

##export PATH=$CONDA_ENV/bin:$PATH
##export PYTHONPATH=$PWD/steps_kt:$CONDA_ENV/lib/python${PYTHON_VERSION}/site-packages:$PYTHONPATH
##export LD_LIBRARY_PATH=$CONDA_ENV/lib:$LD_LIBRARY_PATH

###################################################################################################
##source /idiap/user/dspavankumar/tools/miniconda3/bin/activate legacy
##export PYTHONPATH=$PWD/steps:$PYTHONPATH
echo "Python Path before: " $PYTHONPATH
##export PYTHONPATH="${PWD}/steps:${PYTHONPATH}"
echo "Python Path after export: " $PYTHONPATH
echo "Python version " $(python -V)
echo "which python "$(which python)

##/remote/idiap.svm/home.active/tpurohit/Tilak_Codes/path_check.py

##exit

arch="$1"       ## Model architecture
iter="${2:-1}"

[ -z $arch ] && echo "Model architecture not provided. Defaulting to \"subseg\"." && arch=subseg
exp=/idiap/temp/tpurohit/IEMOCAP-SD/exp/exp_f1/cnn_${arch}_${iter}   ## Output directory

##/idiap/temp/tpurohit/IEMOCAP-SD/lists/F1/train.list

## Wav file lists
train_list=/idiap/temp/tpurohit/IEMOCAP-SD/lists/F1/train.list
cv_list=/idiap/temp/tpurohit/IEMOCAP-SD/lists/F1/cv.list
test_list=/idiap/temp/tpurohit/IEMOCAP-SD/lists/F1/test.list

## Feature directories
train_feat=/idiap/temp/tpurohit/IEMOCAP-SD/feat/F1/train_feat
cv_feat=/idiap/temp/tpurohit/IEMOCAP-SD/feat/F1/cv_feat
test_feat=/idiap/temp/tpurohit/IEMOCAP-SD/feat/F1/test_feat

## Extract features
[ -d $cv_feat ] || python /idiap/temp/tpurohit/IEMOCAP-SD/steps/wav2feat.py $cv_list $cv_feat "train"
[ -d $train_feat ] || python /idiap/temp/tpurohit/IEMOCAP-SD/steps/wav2feat.py $train_list $train_feat "train"
[ -d $test_feat ] || python /idiap/temp/tpurohit/IEMOCAP-SD/steps/wav2feat.py $test_list $test_feat "test"

## Train
[ -f $exp/cnn.h5 ] || python /idiap/temp/tpurohit/IEMOCAP-SD/steps/train.py $train_feat $cv_feat $exp $arch
[ ! -f $exp/cnn.h5 ] && echo "Training failed. Check logs." && exit 1

## Test
[ -s $exp/scores.txt ] || python /idiap/temp/tpurohit/IEMOCAP-SD/steps/test.py $test_feat $exp/cnn.h5 > $exp/scores.txt
[ ! -s $exp/scores.txt ] && echo "Testing failed. Check logs." && exit 1
