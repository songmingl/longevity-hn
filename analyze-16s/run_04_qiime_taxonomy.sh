#!/usr/bin/env bash
set -euo pipefail

# Variable Definitions
CLASSIFIER="silva-138-99-nb-classifier.qza"
INPUT_READS="rep-seqs-dada2.qza"
TAXONOMY_OUT="taxonomy.qza"

TAXONOMY_VIS="taxonomy.qzv" 
FEATURE_TABLE="table.qza"
METADATA_FILE="sample.tsv"
BARPLOT_VIS="taxa-bar-plots.qzv"
EXPORT_DIR="phyloseq"

# 1. Taxonomy Assignment
echo "Running feature classifier..."
qiime feature-classifier classify-sklearn \
  --i-classifier "$CLASSIFIER" \
  --i-reads "$INPUT_READS" \
  --o-classification "$TAXONOMY_OUT"

# 2. Convert to Visualization
echo "Converting taxonomy to visualization..."
qiime metadata tabulate \
  --m-input-file "$TAXONOMY_OUT" \
  --o-visualization "$TAXONOMY_VIS"

# 3. Export .tsv Table Results
echo "Exporting taxonomy results..."
qiime tools export \
  --input-path "$TAXONOMY_OUT" \
  --output-path "$EXPORT_DIR"

# 4. Generate Taxonomy Barplots
echo "Generating taxonomy barplots..."
qiime taxa barplot \
  --i-table "$FEATURE_TABLE" \
  --i-taxonomy "$TAXONOMY_OUT" \
  --m-metadata-file "$METADATA_FILE" \
  --o-visualization "$BARPLOT_VIS"

echo "Taxonomy classification and visualization steps completed!"