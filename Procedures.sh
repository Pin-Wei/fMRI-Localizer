#!/bin/tcsh

set sid = $1

python Gen_localizer_timing.py $sid
# Organize the excel files (.txt) export from E-DataAid files into event.tsv files.

bash Run_heudiconv.sh $sid 
# Convert DICOM images to NIfTI format, while automatically organizing the dataset to conform to the BIDS format.
# + Official Documentation: https://heudiconv.readthedocs.io/en/latest/
# + Tutorial: https://reproducibility.stanford.edu/bids-tutorial-series-part-2a/
# + Note: You have to modify heuristic.py according to your needs.

bash Run_fmriprep.sh $sid
# Perform data pre-processing using standardized (and automated) procedures.
# + Official Documentation: https://fmriprep.org/en/stable/
# + Tutorial (Andy's brain book): https://andysbrainbook.readthedocs.io/en/latest/OpenScience/OS/fMRIPrep.html
# + Tutorial (Stanford): https://reproducibility.stanford.edu/fmriprep-tutorial-running-the-docker-image/#fmriprep1
# + Tutorial (Gelana Tostaeva): https://medium.com/@gelana/using-fmriprep-for-fmri-data-preprocessing-90ce4a9b85bd
# + Tutorial (UAB;vedio): https://www.youtube.com/watch?v=4W6qBIpE404&list=PLfodFxaCrr0eNkoc2F1IOidg4qe_TuOT4&index=3

sudo chmod -R 777 /media/data2/pinwei/Testing_Localizer/Nifti/derivatives/fMRIPrep

bash Tidy_fmriprep_outs.sh $sid
bash Make_timings.sh $sid
bash Modify_confounds.sh $sid
tcsh Run_afni-proc.sh $sid
# Perform first-level analysis.
# + Just visit their website, it contains a wealth of information.
# + Note: fMRIPrep do perform slice-timing correction.
# + Useful discussion posts: https://discuss.afni.nimh.nih.gov/t/for-those-who-are-interested-in-using-fmriprep-output-as-input-for-afni-proc/7142