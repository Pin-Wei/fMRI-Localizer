#!/bin/bash

fmriprep-docker \
   ../ ../derivatives/fMRIPrep participant     \
   --participant-label $1                      \
   --skip_bids_validation                      \
   --output-spaces T1w MNI152NLin2009cAsym     \
   --fs-license-file freesurfer_license.txt    \
   --fs-subjects-dir ../derivatives/FreeSurfer \
   --force-syn           \
   --nthreads 10         \
   --omp-nthreads 10     \
   --stop-on-first-crash \
   --mem_mb 64           \
   -w ../../work/        \
   -v