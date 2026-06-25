#!/usr/bin/env bash
set -euo pipefail

# Convert SRA to gzipped FASTQ and/or prefetch SRA accession list
# Edit the variables below before running.

THREADS=1
SRA_OPTION_FILE="PRJNA797529.txt"    # the file with accessions for prefetch
OUTDIR="seq"                          # output directory for FASTQ files

mkdir -p "$OUTDIR"

if [[ -f "$SRA_OPTION_FILE" ]]; then
  echo "Prefetching accessions listed in $SRA_OPTION_FILE"
  prefetch --option-file "$SRA_OPTION_FILE" || echo "prefetch returned non-zero";
fi

# Create a script to convert all downloaded .sra files to FASTQ (split paired reads)
echo "Generating sra->fastq conversion script"
for i in SRR*; do
  echo "fastq-dump --split-3 --gzip $i -O $OUTDIR"
done > sra_fastq_cmds.sh

# RUN
nohup bash sra_fastq_cmds.sh > sra_fastq.log 2>&1 
