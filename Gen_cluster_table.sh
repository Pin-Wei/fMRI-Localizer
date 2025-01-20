#!/usr/bin/env tcsh

set top_dir = /media/data2/pinwei/Testing_Localizer/Nifti

set input_dir = $top_dir/derivatives/group_analysis/ttest

set suffix = '1sided.ETACmask.global.1pos.05perc.nii.gz'
# set suffix = '2sided.ETACmask.global.2sid.05perc.nii.gz'
	# Input should be a binary mask.
	# It can be an output from ETAC that indicates which voxels survived the multi-thresholding process.	
	# The name of such a file follows the format: {PREFIX}.{NAME}.ETACmask.global.{SIDE}.{FPR}.nii.gz
	# {PREFIX} is what you specified in '-prefix_clustsim'.

set atlas_file = /usr/local/abin/FS.afni.MNI2009c_asym.nii.gz
	# see more AFNI's atlas in: /usr/local/abin/AFNI_atlas_spaces.niml

foreach cond ( \
	'Mot_L'  \
	'Mot_R'  \
	'Motor'  \
	'Calc'   \
	'Lingui' \
	'Visual' \
	'Video'  \
	'Audio'  \
)
	set input_file = $input_dir/etac_${cond}.$suffix
	
	gen_cluster_table \
		-input_clust $input_file \
		-input_atlas $atlas_file \
		-workdir work \
		-prefix $input_dir/cluster_table_${cond}.txt
end

