#!/usr/bin/env bash
set -euo pipefail

# Import sequences into QIIME2
# Configure these variables before running
MANIFEST="sample.tsv"   # path to manifest or metadata file
PAIRED=true              # set to true for paired-end import, false for single-end

# paired data
echo "Importing paired-end sequences using manifest $MANIFEST"
qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path "$MANIFEST" --output-path demux-summary.qza --input-format PairedEndFastqManifestPhred33V2

# single-end data
echo "Importing single-end sequences using manifest $MANIFEST"
qiime tools import --type 'SampleData[SequencesWithQuality]' \
  --input-path "$MANIFEST" --output-path single-end-demux.qza --input-format SingleEndFastqManifestPhred33V2


echo "Generate summary visualization (demux-summary.qzv)"
qiime demux summarize --i-data demux-summary.qza --o-visualization demux-summary.qzv
qiime demux summarize --i-data single-end-demux.qza --o-visualization demux-summary.qzv

