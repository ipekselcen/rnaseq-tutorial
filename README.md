# RNA-seq Analysis: Dnmt1 in Neonatal OPCs

Complete RNA-seq analysis pipeline from raw reads to biological insights.

## Dataset

**GEO Accession:** GSE79018  
**Organism:** Mouse (*Mus musculus*)  
**Cell Type:** Neonatal oligodendrocyte progenitor cells  
**Comparison:** Dnmt1 KO vs Control (2 replicates each)  
**Sequencing:** Illumina paired-end RNA-seq

## Quick Start

```bash
# Clone repository
git clone https://github.com/ipekselcen/rnaseq-tutorial.git
cd rnaseq-tutorial

# Create environment
conda env create -f environment.yml
conda activate rnaseq

# Run complete pipeline
bash scripts/run_pipeline.sh
```

**Runtime:** 4-6 hours

## Workflow

```
1. Download data          → 01_download_data.sh
2. Quality control        → 02_quality_control.sh
3. Trim adapters          → 03_trim_reads.sh
4. Align reads            → 04_align_reads.sh
5. Count genes            → 05_count_reads.sh
6. Differential expression → 06_differential_expression.R
7. Pathway analysis       → 07_pathway_analysis.R
```

## Key Results

**XX differentially expressed genes** (FDR < 0.05, |log₂FC| > 1)

- Upregulation of 

## Tools

**Preprocessing:** FastQC, Trim Galore  
**Alignment:** STAR  
**Quantification:** featureCounts  
**Analysis:** DESeq2, clusterProfiler  
**Visualization:** ggplot2, ComplexHeatmap, EnhancedVolcano

## Output Files

```
results/
├── qc/                    # Quality control reports
├── aligned/               # BAM files
├── counts/                # Count matrix
├── deg/                   # DESeq2 results
├── pathways/              # GO and KEGG enrichment
└── figures/               # All plots (300 DPI PNG)
```

## Requirements

**Software:**
- R ≥ 4.0
- STAR ≥ 2.7.0
- SAMtools ≥ 1.15
- FastQC ≥ 0.11.9

**R Packages:**
```r
# Install Bioconductor packages
BiocManager::install(c("DESeq2", "clusterProfiler", "org.Mm.eg.db", 
                       "EnhancedVolcano", "ComplexHeatmap"))

# Install CRAN packages
install.packages(c("ggplot2", "pheatmap", "dplyr", "ggrepel"))
```

## Project Structure

```
rnaseq-tutorial/
├── README.md
├── environment.yml
├── data/
│   ├── raw/              # FASTQ files
│   └── reference/        # Genome and annotation
├── scripts/
│   ├── 01_download_data.sh
│   ├── 02_quality_control.sh
│   ├── 03_trim_reads.sh
│   ├── 04_align_reads.sh
│   ├── 05_count_reads.sh
│   ├── 06_differential_expression.R
│   ├── 07_pathway_analysis.R
│   └── run_pipeline.sh
└── results/
    ├── qc/
    ├── counts/
    ├── deg/
    ├── pathways/
    └── figures/
```

## Citation

Data from: Moyon et al. (2016) "Functional Characterization of DNA Methylation in the Oligodendrocyte Lineage." *Cell Reports* doi: 10.1016/j.celrep.2016.03.060.  Epub 2016 Apr 14.