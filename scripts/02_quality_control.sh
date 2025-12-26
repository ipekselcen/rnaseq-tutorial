#!/bin/bash
# Quality control with FastQC and MultiQC

set -e

echo "Running quality control"
echo ""

# Directories
RAW_DIR="data/raw"
QC_DIR="results/qc/raw"
THREADS=8

mkdir -p ${QC_DIR}

# FastQC
echo "Running FastQC..."
fastqc \
  ${RAW_DIR}/*.fastq.gz \
  --outdir ${QC_DIR} \
  --threads ${THREADS} \
  --quiet

# MultiQC
echo "Generating MultiQC report..."
multiqc \
  ${QC_DIR} \
  --outdir ${QC_DIR} \
  --filename multiqc_report \
  --title "RNA-seq QC - Raw Reads" \
  --force

echo ""
echo "✓ QC complete"
echo ""
echo "View report: ${QC_DIR}/multiqc_report.html"
echo ""
echo "Next: bash scripts/03_trim_reads.sh"
