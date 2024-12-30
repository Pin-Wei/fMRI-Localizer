#!/bin/bash

task='localizer'

top_dir='/media/data2/pinwei/Testing_Localizer/Nifti'

subj=sub-$1

conf_dir=$top_dir/derivatives/fMRIPrep/$subj/func/Confounds

input_tsv=$conf_dir/${subj}_task-${task}_desc-confounds_timeseries.tsv

for conf_name in 'head-motion' 'csf+wm'; do
	
	output_cbind=$conf_dir/${conf_name}.1D 
	if [ -f $output_cbind ]; then rm $output_cbind; fi
	
	case $conf_name in
		'head-motion')
			conf_list=( trans_x trans_y trans_z rot_x rot_y rot_z )
		;;
		'csf+wm')
			conf_list=( csf white_matter )
		;;
	esac
		
	for conf in ${conf_list[*]}; do
	
		output_per_conf=$conf_dir/${conf/_/-}.txt
		
		## print the column whose header is matched:
		awk -v col=$conf 'NR==1 { 
				for (i=1; i<=NF; i++) { if ($i==col) {c=i; break} } 
			} NR>1 {print $c}' $input_tsv > $output_per_conf
		
		## column binding confound time series:
		if [ ! -f $output_cbind ]; then 
			cat $output_per_conf > $output_cbind
		else
			paste $output_cbind $output_per_conf > $conf_dir/temp.1D
			mv $conf_dir/temp.1D $output_cbind
		fi
	done
done

