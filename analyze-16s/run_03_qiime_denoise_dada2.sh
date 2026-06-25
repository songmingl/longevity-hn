#!/usr/bin/env bash
set -euo pipefail

# Run QIIME2 DADA2 denoising (paired or single). Edit parameters below.

TABLE_OUT="table.qza"
REPS_OUT="rep-seqs-dada2.qza"
STATS_OUT="dada2-stats.qza"
FEATUR_OUTDIR="exported_feature_table"

# paired data
TRIM_LEFT_F=17
TRIM_LEFT_R=17
TRUNC_LEN_F=251
TRUNC_LEN_R=251
DEMUX_QZA="demux-summary.qza"
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs "$DEMUX_QZA" \
  --o-table "$TABLE_OUT" \
  --o-representative-sequences "$REPS_OUT" \
  --o-denoising-stats "$STATS_OUT" \
  --p-trim-left-f "$TRIM_LEFT_F" --p-trim-left-r "$TRIM_LEFT_R" \
  --p-trunc-len-f "$TRUNC_LEN_F" --p-trunc-len-r "$TRUNC_LEN_R"

# Single-end example parameters
TRIM_LEFT=50
TRUNC_LEN=1400
DEMUX_QZA="single-end-demux.qza"
qiime dada2 denoise-single \
  --i-demultiplexed-seqs "$DEMUX_QZA" \
  --p-trim-left "$TRIM_LEFT" --p-trunc-len "$TRUNC_LEN" \
  --o-representative-sequences "$REPS_OUT" --o-table "$TABLE_OUT" --o-denoising-stats "$STATS_OUT"

# Export basic visualizations
qiime metadata tabulate --m-input-file "$STATS_OUT" --o-visualization dada2-stats.qzv || true
qiime feature-table summarize --i-table "$TABLE_OUT" --o-visualization table.qzv || true
qiime feature-table tabulate-seqs --i-data "$REPS_OUT" --o-visualization rep-seqs-dada2.qzv || true

echo "Extract OTU/ASV from qza file"
qiime tools export --input-path "${TABLE_OUT}" --output-path "${FEATUR_OUTDIR}"
biom convert -i "${FEATUR_OUTDIR}/feature-table.biom" -o ASV_table.tsv --to-tsv
qiime tools export --input-path "${REPS_OUT}" --output-path "${FEATUR_OUTDIR}"