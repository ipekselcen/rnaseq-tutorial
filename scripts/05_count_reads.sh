#!/bin/bash
# Count reads per gene with featureCounts

set -e

echo "Counting reads per gene"
echo ""

# Directories
ALIGN_DIR="results/aligned"
COUNT_DIR="results/counts"
REF_DIR="data/reference"
THREADS=16

mkdir -p ${COUNT_DIR}

# Get all BAM files
BAM_FILES=(${ALIGN_DIR}/*_Aligned.sortedByCoord.out.bam)
GTF="${REF_DIR}/Mus_musculus.GRCm39.115.gtf"

# Count with featureCounts
echo "Running featureCounts..."
featureCounts \
  -p \
  -B \
  -C \
  -T ${THREADS} \
  -a ${GTF} \
  -o ${COUNT_DIR}/gene_counts.txt \
  ${BAM_FILES[@]}

# Clean count matrix
echo ""
echo "Creating clean count matrix..."
head -n 1 ${COUNT_DIR}/gene_counts.txt | \
  cut -f1,7- | \
  sed 's|results/aligned/||g' | \
  sed 's|_Aligned.sortedByCoord.out.bam||g' > ${COUNT_DIR}/count_matrix_clean.txt

tail -n +2 ${COUNT_DIR}/gene_counts.txt | \
  cut -f1,7- >> ${COUNT_DIR}/count_matrix_clean.txt

echo ""
echo "✓ Counting complete"
echo ""
echo "Count matrix: ${COUNT_DIR}/count_matrix_clean.txt"
echo ""
cat ${COUNT_DIR}/gene_counts.txt.summary | column -t
echo ""
echo "Next: Rscript scripts/06_differential_expression.R"
