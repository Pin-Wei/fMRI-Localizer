#!/bin/bash

# docker run --rm -it -v /media/data2/pinwei/Testing_Localizer:/base \
	# nipy/heudiconv:latest \
	# -d /base/Dicom/S{subject}/*/*.IMA \
	# -o /base/Nifti/ \
	# -f convertall \
	# -s $1 \
	# -c none \
	# --overwrite
	
docker run --rm -it -v /media/data2/pinwei/Testing_Localizer:/base \
	nipy/heudiconv:latest \
	-d /base/Dicom/S{subject}/*/*.IMA \
	-o /base/Nifti/ \
	-f /base/Nifti/code/heuristic.py \
	-s $1 \
	-c dcm2niix \
	-b --overwrite