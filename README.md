# fMRI-Localizer
These scripts are adapted from my previous project, retaining only the core elements to serve as a foundation for analyzing a new fMRI project. 

The dataset processed by the scripts is derived from a localizer task in an fMRI experiment. Specifically, they are collected from a senior named Anya and stored on "Super Computer 2" (a desktop located in 609-3). However, for some reason, E-DataAid files for many participants are missing or incomplete. Consequently, I selected data from only two participants to ensure that the scripts could run as intended.
The dataset is, of course, not uploaded here (GitHub).

The following outlines the procedures along with some footnotes.

## 1. Organize the excel (.txt) files export from E-DataAid files into event.tsv files.
   Execute `python Gen_localizer_timing.py $sid`
   
## 2. Convert DICOM images to NIfTI format, while automatically organizing the dataset to conform to the BIDS format. 
   Execute `bash Run_heudiconv.sh $sid` 
   + Official Documentation: https://heudiconv.readthedocs.io/en/latest/
   + Tutorial: https://reproducibility.stanford.edu/bids-tutorial-series-part-2a/
   + Notably, you have to modify heuristic.py according to your needs.

## 3. Perform data pre-processing using standardized (and automated) procedures.
   Execute `bash Run_fmriprep.sh $sid`
   + Official Documentation: https://fmriprep.org/en/stable/
   + Tutorial (Andy's brain book): https://andysbrainbook.readthedocs.io/en/latest/OpenScience/OS/fMRIPrep.html
   + Tutorial (Stanford): https://reproducibility.stanford.edu/fmriprep-tutorial-running-the-docker-image/#fmriprep1
   + Tutorial (Gelana Tostaeva): https://medium.com/@gelana/using-fmriprep-for-fmri-data-preprocessing-90ce4a9b85bd
   + Tutorial (UAB): https://www.youtube.com/watch?v=4W6qBIpE404&list=PLfodFxaCrr0eNkoc2F1IOidg4qe_TuOT4&index=3

## 4. Some intermediate steps.
   Execute `bash Tidy_fmriprep_outs.sh $sid`, `bash Make_timings.sh $sid`, and `bash Modify_confounds.sh $sid`
   The purpose of each script can be known from its name.

## 5. Perform first-level analysis.
   Execute `tcsh Run_afni-proc.sh $sid`
   + Just visit their website, it contains a wealth of information.
   + Note: fMRIPrep does perform slice-timing correction.
   + Useful discussion posts: https://discuss.afni.nimh.nih.gov/t/for-those-who-are-interested-in-using-fmriprep-output-as-input-for-afni-proc/7142

To be continued...
