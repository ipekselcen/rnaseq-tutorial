#!/bin/bash
# Downloads RNA-seq data from GEO (GSE79018)

set -e

echo "Downloading RNA-seq data (GSE79018)"
echo ""

# Create directories
mkdir -p data/raw data/reference results/qc

# SRA accessions
SRA_IDS=("SRR3212794" "SRR3212795" "SRR3212796" "SRR3212797")

# Download FASTQ files
echo "Downloading FASTQ files..."
for SRA_ID in "${SRA_IDS[@]}"; do
  
  if [ -f "data/raw/${SRA_ID}_1.fastq.gz" ]; then
    echo "  ${SRA_ID} - already exists"
    continue
  fi
  
  echo "  Downloading ${SRA_ID}..."
  
  fasterq-dump ${SRA_ID} \
    --outdir data/raw \
    --threads 4 \
    --split-files
    
  gzip data/raw/${SRA_ID}_1.fastq
  gzip data/raw/${SRA_ID}_2.fastq
done

echo ""
echo "Downloading reference genome..."
cd data/reference

# Mouse reference genome (GRCm39)
if [ ! -f "Mus_musculus.GRCm39.dna.primary_assembly.fa" ]; then
  wget https://ftp.ensembl.org/pub/release-115/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna.primary_assembly.fa.gz
  gunzip Mus_musculus.GRCm39.dna.primary_assembly.fa.gz
else
  echo "  Genome already exists"
fi

# Gene annotation
if [ ! -f "Mus_musculus.GRCm39.115.gtf" ]; then
  wget https://ftp.ensembl.org/pub/release-115/gtf/mus_musculus/Mus_musculus.GRCm39.115.gtf.gz
  gunzip Mus_musculus.GRCm39.115.gtf.gz
else
  echo "  Annotation already exists"
fi

cd ../..

# Create metadata
cat > data/metadata.csv << 'EOF'
sample_id,sra_id,condition,replicate,fastq_1,fastq_2
Control_1,SRR3212794,Control,1,data/raw/SRR3212794_1.fastq.gz,data/raw/SRR3212794_2.fastq.gz
Control_2,SRR3212795,Control,2,data/raw/SRR3212795_1.fastq.gz,data/raw/SRR3212795_2.fastq.gz
Dnmt1_KO_1,SRR3212797,Dnmt1_KO,1,data/raw/SRR3212797_1.fastq.gz,data/raw/SRR3212797_2.fastq.gz
Dnmt1_KO_2,SRR3212798,Dnmt1_KO,2,data/raw/SRR3212798_1.fastq.gz,data/raw/SRR3212798_2.fastq.gz
EOF

echo ""
echo "✓ Download complete"
echo ""
echo "Downloaded:"
echo "  4 samples (2 Control, 2 Dnmt1 KO)"
echo "  Mouse genome (GRCm39)"
echo "  Gene annotation (Ensembl 115)"
echo ""
echo "Next: bash scripts/02_quality_control.sh"
