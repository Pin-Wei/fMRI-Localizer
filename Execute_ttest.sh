#!/usr/bin/env tcsh

set afni_dir   = ../derivatives/afni_proc_outs
set mask_dir   = ../derivatives/group_analysis
set output_dir = ../derivatives/group_analysis/ttest
if ( ! -d $output_dir ) mkdir $output_dir
set script_dir = ./generated_group-test_cmds
if ( ! -d $script_dir ) mkdir $script_dir

foreach glt ( \
	'Mot_L'   \
	'Mot_R'   \
	'Motor'   \
	'Calc'    \
	'Lingui'  \
	'Visual'  \
	'Video'   \
	'Audio'   \
)
	gen_group_command.py -command 3dttest++               \
		-write_script ./cmd_tt++_$glt                     \
		-prefix $output_dir/tt++_$glt                     \
		-dsets $afni_dir/*.results/stats.*_REML+tlrc.HEAD \
		-subs_betas $glt'#0_Coef'                         \
		-options -overwrite                               \
			-mask $mask_dir/group_mask+tlrc 
			
		## Tmeporally muted, since the number of subject is insufficient:
			# -Clustsim -ETAC -seed 0 0                     \
			# -tempdir work                                 \
			# -prefix_clustsim $output_dir/etac_$glt        \
			# -ETAC_opt NN=3:sid=1:pthr=0.05,0.01,0.005,0.001:name=1sided \
			# -ETAC_opt NN=3:sid=2:pthr=0.05,0.01,0.005,0.001:name=2sided

	tcsh cmd_tt++_$glt
	
	if ( -f $script_dir/cmd_tt++_$glt ) rm $script_dir/cmd_tt++_$glt
	mv cmd_tt++_$glt $script_dir
end

## ----------------------------------------------------------

# Details and differences between Clustsim and ETAC, see: 
# https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/programs/alpha/3dttest%2B%2B_sphx.html#id7

# Use '-CLUSTSIM' will include the z-scores from all the simulations.
# The permutation/randomization z-scores are saved in '.sdat' format.
# You can change the number of simulations using an option such as '-DAFNI_TTEST_NUMCSIM=20000' if you like. 

## other conditions: 
# 'CE' 'CL' 'CDE' 'CDL' 'CGE' 'CGL' 'DH' 'DV' 'PE' 'PL'

## other general linear tests: 
# 'Mot_L-R' 
# 'Mot_R-L' 
# 'Vis_H-V' 
# 'Vis_V-H' 
# 'Vid-Aud' 
# 'Aud-Vid' 
# 'Motor-Cog' 
# 'Cog-Motor'