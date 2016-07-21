#!/usr/bin/Rscript
#
# Pipeline for Segmentation
#
# Copyright (C) 2016  John Muschelli
# Released under GPL (>= 2)

## load docopt package
suppressMessages(library(docopt))       
# we need docopt (>= 0.3) 

## configuration for docopt
doc <- "Usage: segment.r [--flair=<FLAIR>] [--t1_pre=<T1PRE>] [--t1_post=<T1POST>] [--t2=<T2>] [--pd=<PD>] [--lesion=<GOLD>] [--outdir=<ODIR>] [-h] ID OUTFILE

Options:
-f --flair=<FLAIR>     FLAIR Image [default: 3DFLAIR.nii.gz]
-s --t1_pre=<T1PRE>    T1-Pre GAD Image [default: 3DT1.nii.gz]
-t --t1_post=<T1POST>   T1-Post GAD Image [default: 3DT1GADO.nii.gz]
-u --t2=<T2>   T2 Image [default: T2.nii.gz]
-p --pd=<PD>   PD Image [default: DP.nii.gz]
-l --lesion=<GOLD>   Gold Standard Image/Segmentation [default: NULL]
-o --outdir=<ODIR>   Output directory for intermediary [default: '.']
-h --help           show this help text

Arguments:
ID        ID of patient
OUTFILE   Output filename
"

opt = docopt(doc)
print(opt)

###########################################
# Model MS Lesions
############################################
library(methods)
library(msseg)


ofile = opt$OUTFILE
t1_pre = opt[["--t1_pre"]]
t1_post = opt[["--t1_post"]]
flair = opt[["--flair"]]
t2 = opt[["--t2"]]
pd = opt[["--pd"]]
gold_standard = opt[["--lesion"]]
outdir = opt[["--outdir"]]

niis = c(
    FLAIR = flair,
    T1_Pre = t1_pre,
    T1_Post = t1_post,
    T2 = t2,
    PD = pd)
if (is.character(gold_standard)) {
  if (gold_standard %in% c("NULL", "")) {
    gold_standard = NULL
  }
}

if (!all_exists(niis)) {
    stop("Not all files passed in exist!")
}

msseg_pipeline(
  t1_pre = t1_pre,
  t1_post = t1_post,
  flair = flair,
  t2 = t2,
  pd = pd,
  gold_standard = gold_standard,
  outdir = outdir,
  outfile = ofile,
  num_templates = 15,
  verbose = TRUE)