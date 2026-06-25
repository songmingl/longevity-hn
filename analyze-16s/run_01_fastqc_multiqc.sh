#!/usr/bin/env bash
set -euo pipefail

# Run FastQC on input fastq files and aggregate with MultiQC
# Edit SAMPLE_LIST or point to a manifest as needed.

THREADS=1

# Run FastQC on all fastq.gz files in current directory
echo "Running FastQC on all *.fastq.gz files"
OUTDIR="qc"
mkdir -p "$OUTDIR"
fastqc -o "$OUTDIR" -t "$THREADS" *.fastq.gz > qc.log
fastqc -o qc/ -t "${THREADS}" seq/*.fastq.gz >> qc.log

# paired files are separated into _1/_2, run on each seT
echo "Running FastQC on paired _1/_2 files"
OUTDIR="qc1"
mkdir -p "$OUTDIR"
fastqc -o "$OUTDIR" -t "$THREADS" *_1.fastq.gz >> qc.log

OUTDIR="qc2"
mkdir -p "$OUTDIR"
fastqc -o "$OUTDIR" -t "$THREADS" *_2.fastq.gz >> qc.log

# aggregate in qc folder
echo "Running MultiQC to aggregate QC results"
cd qc
multiqc ./
