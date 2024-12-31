#!/usr/bin/env tcsh

set task  = 'localizer'
set space = 'MNI152NLin2009cAsym'

set top_dir = /media/data2/pinwei/Testing_Localizer/Nifti
set prep_dir = $top_dir/derivatives/fMRIPrep
set output_dir = $top_dir/derivatives/group_analysis
if ( ! -d $output_dir ) mkdir $output_dir

## group func mask:
3dmask_tool -overwrite -quiet \
	-inputs $prep_dir/sub-*/func/Masks/sub-*_task-${task}_space-${space}_desc-brain_mask.nii.gz \
	-prefix $output_dir/union_func_mask \
	-union -fill_holes -NN3
	
## group anat mask:
3dmask_tool -overwrite -quiet \
	-inputs $prep_dir/sub-*/anat/sub-*_space-${space}_desc-brain_mask.nii.gz \
	-prefix $output_dir/union_anat_mask \
	-union -fill_holes -NN3
	
## resample group anat mask to func resolution:
3dresample -overwrite \
	-input $output_dir/union_anat_mask+tlrc   \
	-master $output_dir/union_func_mask+tlrc  \
	-prefix $output_dir/union_anat_mask_resam \
	-rmode NN
	
## intersection between anat and func mask:
3dmask_tool -overwrite -quiet \
	-inputs $output_dir/union_func_mask+tlrc $output_dir/union_anat_mask_resam+tlrc \
	-prefix $output_dir/group_mask \
	-inter -fill_holes
