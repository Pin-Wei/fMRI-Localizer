#!/usr/bin/env tcsh

set subj = sub-$1

set task  = 'localizer'
set space = 'MNI152NLin2009cAsym'
set model = 'dmBLOCK'
   
set prefix = proc.241227

set top_dir  = /media/data2/pinwei/Testing_Localizer/Nifti

set script_dir = $top_dir/derivatives/afni_proc_scripts
if ( ! -d $script_dir ) mkdir $script_dir

set output_dir = $top_dir/derivatives/afni_proc_outs
if ( ! -d $output_dir ) mkdir $output_dir

set anat_dir = $top_dir/derivatives/fMRIPrep/$subj/anat
set mask_dir = $top_dir/derivatives/fMRIPrep/$subj/func/Masks
set bold_dir = $top_dir/derivatives/fMRIPrep/$subj/func/MNI_space
set stim_dir = $top_dir/derivatives/fMRIPrep/$subj/func/Timings
set conf_dir = $top_dir/derivatives/fMRIPrep/$subj/func/Confounds

afni_proc.py -subj_id $subj               \
	-script $script_dir/$prefix.$subj.sh  \
	-scr_overwrite                        \
	-blocks mask blur scale regress       \
	-copy_anat                            \
		$anat_dir/${subj}_space-${space}_desc-preproc_T1w.nii.gz \
	-anat_has_skull no                    \
	-dsets                                \
		$bold_dir/${subj}_task-${task}_space-${space}_desc-preproc_bold.nii.gz \
	-tcat_remove_first_trs 0              \
	-mask_import fmriprep_bold_mask       \
		$mask_dir/${subj}_task-${task}_space-${space}_desc-brain_mask.nii.gz \
	-mask_apply fmriprep_bold_mask        \
	-mask_epi_anat yes                    \
	-blur_size 4.0                        \
	-blur_in_mask yes                     \
	-regress_polort 2                     \
	-regress_stim_times                   \
		$stim_dir/localizer_CE.1D         \
		$stim_dir/localizer_CL.1D         \
		$stim_dir/localizer_CDE.1D        \
		$stim_dir/localizer_CDL.1D        \
		$stim_dir/localizer_CGE.1D        \
		$stim_dir/localizer_CGL.1D        \
		$stim_dir/localizer_DH.1D         \
		$stim_dir/localizer_DV.1D         \
		$stim_dir/localizer_PE.1D         \
		$stim_dir/localizer_PL.1D         \
	-regress_stim_labels                  \
		CE CL CDE CDL CGE CGL DH DV PE PL \
	-regress_stim_times_offset -0.962     \
	-regress_stim_types AM2               \
	-regress_basis $model                 \
	-regress_extra_ortvec                 \
		$conf_dir/csf+wm.1D               \
	-regress_extra_ortvec_labels          \
		CSF_WM                            \
	-regress_motion_file $conf_dir/head-motion.1D \
	-regress_apply_mot_types basic        \
	-regress_censor_motion 0.3            \
	-regress_censor_outliers 0.05         \
	-regress_opts_3dD                     \
		-jobs 12                          \
		-num_glt 16                       \
		-gltsym 'SYM: CGE + CGL' -glt_label 1 'Mot_L' \
		-gltsym 'SYM: CDE + CDL' -glt_label 2 'Mot_R' \
		-gltsym 'SYM: CGE + CGL + CDE + CDL' -glt_label 3 'Motor' \
		-gltsym 'SYM: CGE + CGL - CDE - CDL' -glt_label 4 'Mot_L-R' \
		-gltsym 'SYM: CDE + CDL - CGE - CGL' -glt_label 5 'Mot_R-L' \
		-gltsym 'SYM: CL + CE' -glt_label 6 'Calc' \
		-gltsym 'SYM: PL + PE' -glt_label 7 'Lingui' \
		-gltsym 'SYM: DH + DV' -glt_label 8 'Visual' \
		-gltsym 'SYM: DH - DV' -glt_label 9 'Vis_H-V' \
		-gltsym 'SYM: DV - DH' -glt_label 10 'Vis_V-H' \
		-gltsym 'SYM: CGL + CDL + CL + PL' -glt_label 11 'Video' \
		-gltsym 'SYM: CGE + CDE + CE + PE' -glt_label 12 'Audio' \
		-gltsym 'SYM: CGL + CDL + CL + PL - CGE - CDE - CE - PE' -glt_label 13 'Vid-Aud' \
		-gltsym 'SYM: CGE + CDE + CE + PE - CGL - CDL - CL - PL' -glt_label 14 'Aud-Vid' \
		-gltsym 'SYM: CGE + CGL + CDE + CDL - CL - CE - PL - PE' -glt_label 15 'Motor-Cog' \
		-gltsym 'SYM: CL + CE + PL + PE - CGE - CGL - CDE - CDL' -glt_label 16 'Cog-Motor' \
	-regress_make_ideal_sum sum_ideal.1D  \
	-regress_make_cbucket yes             \
	-regress_compute_fitts                \
	-regress_est_blur_epits               \
	-regress_est_blur_errts               \
	-regress_reml_exec                    \
	-html_review_style pythonic           \
	-execute

if ( -d $subj.results ) mv $subj.results $output_dir/$subj.results

# calculs entendus  = CE  = Audio Calculation
# calculs lus       = CL  = Visual Calculation
# clics D entendus  = CDE = Right Audio Clicks (pressing right button with auditory instruction)
# clics D lus       = CDL = Right Visual Clicks (pressing right button with visual instruction)
# clics G entendus  = CGE = Left Audio Clicks
# clics G lus       = CGL = Left Visual Clicks
# damier H          = DH  = Checkerboard Horizontal (passively viewing flashing horizontal checkboards)
# damier V          = DV  = Checkerboard Vertical
# phrases entendues = PE  = Audio Sentences (listening to short sentence)
# phrases lues      = PL  = Visual Sentences (reading short sentence)