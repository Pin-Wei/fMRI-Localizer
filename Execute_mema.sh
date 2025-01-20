#!/usr/bin/env tcsh

set afni_dir   = ../derivatives/afni_proc_outs
set mask_dir   = ../derivatives/group_analysis
set output_dir = ../derivatives/group_analysis/mema
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
	gen_group_command.py -command 3dMEMA                  \
		-write_script ./cmd_mema_$glt                     \
		-prefix $output_dir/mema_$glt                     \
		-dsets $afni_dir/*.results/stats.*_REML+tlrc.HEAD \
		-subs_betas $glt'#0_Coef'                         \
		-subs_tstats $glt'#0_Tstat'                       \
		-options -overwrite                               \
			-mask $mask_dir/group_mask+tlrc 

	tcsh cmd_mema_$glt
	
	if ( -f $script_dir/cmd_mema_$glt ) rm $script_dir/cmd_mema_$glt
	mv cmd_mema_$glt $script_dir
end

## ----------------------------------------------------------
# MEMA = Mixed Effects Meta Analysis
# https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/programs/alpha/3dMEMA_sphx.html#ahelp-3dmema

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