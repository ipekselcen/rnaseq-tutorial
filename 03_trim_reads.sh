#!/bin/bash
# Trim adapters and low-quality bases

set -e

echo "Trimming reads"
echo ""

# Directories
TRIMMED_DIR="data/trimmed"
QC_DIR="results/qc/trimmed"
THREADS=8

mkdir -p ${TRIMMED_DIR} ${QC_DIR}

# Trim each sample
while IFS=',' read -r sample_id sra_id condition replicate fastq_1 fastq_2; do
  
  if [ "$sample_id" == "sample_id" ]; then
    continue
  fi
  
  if [ -f "${TRIMMED_DIR}/${sra_id}_1_val_1.fq.gz" ]; then
    echo "  ${sample_id} - already trimmed"
    continue
  fi
  
  echo "  Trimming ${sample_id}..."
  
  trim_galore \
    --paired \
    --fastqc \
    --quality 20 \
    --length 36 \
    --cores ${THREADS} \
    --output_dir ${TRIMMED_DIR} \
    ${fastq_1} ${fastq_2}
    
done < data/metadata.csv

# MultiQC
echo ""
echo "Generating QC report..."
multiqc \
  ${TRIMMED_DIR} \
  --outdir ${QC_DIR} \
  --filename trimmed_multiqc_report \
  --title "RNA-seq QC - Trimmed" \
  --force

echo ""
echo "✓ Trimming complete"
echo ""
echo "QC report: ${QC_DIR}/trimmed_multiqc_report.html"
echo ""
echo "Next: bash scripts/04_align_reads.sh"
