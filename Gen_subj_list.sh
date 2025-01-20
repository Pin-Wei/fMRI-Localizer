#!/usr/bin/env tcsh

set top_dir = /media/data2/pinwei/Testing_Localizer/Nifti

cd $top_dir/derivatives/fMRIPrep

if ( -f subjList.txt ) rm subjList.txt

ls -d sub-??? | sed "s|\/||g" > subjList.txt

mv subjList.txt $top_dir/code