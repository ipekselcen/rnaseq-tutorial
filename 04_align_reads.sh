#!/bin/bash
# Align reads to genome with STAR

set -e

echo "Aligning reads with STAR"
echo ""

# Directories
TRIMMED_DIR="data/trimmed"
ALIGN_DIR="results/aligned"
REF_DIR="data/reference"
GENOME_DIR="${REF_DIR}/star_index"
THREADS=16

mkdir -p ${ALIGN_DIR} ${GENOME_DIR}

# Reference files
GENOME_FASTA="${REF_DIR}/Mus_musculus.GRCm39.dna.primary_assembly.fa"
GTF="${REF_DIR}/Mus_musculus.GRCm39.115.gtf"

# Build STAR index
if [ ! -f "${GENOME_DIR}/SAindex" ]; then
  echo "Building STAR index (30-60 min)..."
  
  STAR \
    --runMode genomeGenerate \
    --genomeDir ${GENOME_DIR} \
    --genomeFastaFiles ${GENOME_FASTA} \
    --sjdbGTFfile ${GTF} \
    --sjdbOverhang 99 \
    --runThreadN ${THREADS}
else
  echo "Using existing STAR index"
fi

echo ""
echo "Aligning samples..."

# Align each sample
while IFS=',' read -r sample_id sra_id condition replicate fastq_1 fastq_2; do
  
  if [ "$sample_id" == "sample_id" ]; then
    continue
  fi
  
  if [ -f "${ALIGN_DIR}/${sample_id}_Aligned.sortedByCoord.out.bam" ]; then
    echo "  ${sample_id} - already aligned"
    continue
  fi
  
  echo "  Aligning ${sample_id}..."
  
  READ1="${TRIMMED_DIR}/${sra_id}_1_val_1.fq.gz"
  READ2="${TRIMMED_DIR}/${sra_id}_2_val_2.fq.gz"
  
  STAR \
    --runMode alignReads \
    --genomeDir ${GENOME_DIR} \
    --readFilesIn ${READ1} ${READ2} \
    --readFilesCommand zcat \
    --outFileNamePrefix ${ALIGN_DIR}/${sample_id}_ \
    --outSAMtype BAM SortedByCoordinate \
    --outSAMunmapped Within \
    --outSAMattributes Standard \
    --quantMode GeneCounts \
    --runThreadN ${THREADS}
    
done < data/metadata.csv

# Index BAM files
echo ""
echo "Indexing BAM files..."
for BAM in ${ALIGN_DIR}/*_Aligned.sortedByCoord.out.bam; do
  samtools index -@ ${THREADS} ${BAM}
done

# Generate stats
echo ""
echo "Generating alignment statistics..."
echo "sample_id,total_reads,uniquely_mapped,mapped_multiple,unmapped" > ${ALIGN_DIR}/alignment_stats.csv

for LOG in ${ALIGN_DIR}/*_Log.final.out; do
  SAMPLE=$(basename ${LOG} _Log.final.out)
  TOTAL=$(grep "Number of input reads" ${LOG} | awk '{print $NF}')
  UNIQUE=$(grep "Uniquely mapped reads number" ${LOG} | awk '{print $NF}')
  MULTI=$(grep "Number of reads mapped to multiple loci" ${LOG} | awk '{print $NF}')
  UNMAPPED=$(grep "Number of reads unmapped: too short" ${LOG} | awk '{print $NF}')
  echo "${SAMPLE},${TOTAL},${UNIQUE},${MULTI},${UNMAPPED}" >> ${ALIGN_DIR}/alignment_stats.csv
done

echo ""
echo "✓ Alignment complete"
echo ""
cat ${ALIGN_DIR}/alignment_stats.csv | column -t -s,
echo ""
echo "Next: bash scripts/05_count_reads.sh"
