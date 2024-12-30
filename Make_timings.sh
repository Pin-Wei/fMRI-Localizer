#!/bin/bash

task='localizer'

top_dir='/media/data2/pinwei/Testing_Localizer/Nifti'

subj=sub-$1

output_dir=$top_dir/derivatives/fMRIPrep/$subj/func/Timings
if [ ! -d $output_dir ]; then mkdir $output_dir; fi

event_file=$top_dir/$subj/func/${subj}_task-${task}_events.tsv

cond_list=('CE' 'CL' 'CDE' 'CDL' 'CGE' 'CGL' 'DH' 'DV' 'PE' 'PL')

for cond in ${cond_list[*]}; do

	cat $event_file | \
		awk -v c=$cond '{if ($3 == c) {print $1, $2, "1"}}' > \
		$output_dir/localizer_$cond.txt
		
	timing_tool.py \
		-fsl_timing_files $output_dir/localizer_$cond.txt \
		-write_as_married \
		-write_timing $output_dir/localizer_$cond.1D

done
