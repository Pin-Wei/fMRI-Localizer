#!/usr/bin/env python
# coding: utf-8

import os, io, sys
import numpy as np
import pandas as pd

sid = sys.argv[1]

top_dir = os.path.join("/media", "data2", "pinwei", "Testing_Localizer")
data_dir = os.path.join(top_dir, "Localizer_EDat") 
output_dir = os.path.join(top_dir, "Nifti", f"sub-{sid:02d}", "func")
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

data_name = f"longlocalizercalib_chinese2013-{sid:02d}-1_edat.txt"
# data_name = f"longlocalizercalib_chinese2013_updated-{sid:03d}-1.txt"
output_name = f"sub-{sid:02d}_task-localizer_events.tsv"

# --------------------------------------------------------------------------
data = pd.read_table(
    io.open(os.path.join(data_dir, data_name), 'r', encoding='utf-16-le'), 
    skiprows=1, header=0)

data = data.loc[:, [
    "codeManip", 
    "Manip", 
    "rien.OnsetTime", 
    "check1.OnsetTime", 
    "ImageDisplay2.OnsetTime", 
    "s101.OnsetTime", 
    "StimuliAudio.OnsetTime", 
    "StimuliAudioClic.OnsetTime"
]]

data.loc[:, "Manip"] = data["Manip"].replace({
    "calculs entendus" : "CE",  # Audio Calculation
    "calculs lus"      : "CL",  # Visual Calculation
    "clics D entendus" : "CDE", # Right Audio Clicks (pressing right button with auditory instruction)
    "clics D lus"      : "CDL", # Right Visual Clicks (pressing right button with visual instruction)
    "clics G entendus" : "CGE", # Left Audio Clicks
    "clics G lus"      : "CGL", # Left Visual Clicks
    "damier H"         : "DH",  # Checkerboard Horizontal (passively viewing flashing horizontal checkboards)
    "damier V"         : "DV",  # Checkerboard Vertical
    "phrases entendues": "PE",  # Audio Sentences (listening to short sentence)
    "phrases lues"     : "PL"   # Visual Sentences (reading short sentence)
})

data["X"] = data.iloc[:, 2:].sum(axis=1, numeric_only=True)
data = data.sort_values(by=["codeManip", "X"])

starting_time = list(data.query("Manip == 'repos'")["X"])[0]
data["OnsetTime"] = (data["X"] - starting_time) / 1000

data.drop(data.query("Manip == 'repos'").index, inplace=True)
data.dropna(subset=["Manip"], inplace=True)

data["Duration"] = data["Manip"].apply(
    lambda x: dict(zip(
        ["CE", "CL", "CDE", "CDL", "CGE", "CGL", "DH", "DV", "PE", "PL"], 
        [1.2, 1.3, 1.2, 1.3, 1.2, 1.3, 1.8, 1.8, 1.6, 1.3]
    ))[x]
)

data = data.rename(columns={
    "OnsetTime": "onset", 
    "Duration" : "duration", 
    "Manip"    : "trial_type", 
})

data = data.loc[:, ["onset", "duration", "trial_type"]]

data.to_csv(os.path.join(output_dir, output_name), sep="\t", index=False)
