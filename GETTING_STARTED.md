# Getting Started

## Installation

### 1. Create Environment

```bash
# Clone repository
git clone https://github.com/ipekselcen/rnaseq-tutorial.git
cd rnaseq-tutorial

# Create conda environment
conda env create -f environment.yml
conda activate rnaseq
```

### 2. Verify Installation

```bash
# Test command-line tools
fastqc --version
STAR --version
samtools --version

# Test R packages
Rscript -e "library(DESeq2); library(clusterProfiler)"
```

If all commands work, you're ready!

---

## Running the Analysis

### Option 1: Complete Pipeline

Run everything at once:

```bash
bash scripts/run_pipeline.sh
```

**Runtime:** 4-6 hours  
**What it does:** Downloads data, runs QC, aligns reads, quantifies genes, performs DE analysis, and generates figures

### Option 2: Step-by-Step

Run individual steps:

```bash
# Download data
bash scripts/01_download_data.sh

# Quality control
bash scripts/02_quality_control.sh

# Trim adapters
bash scripts/03_trim_reads.sh

# Align to genome
bash scripts/04_align_reads.sh

# Count reads per gene
bash scripts/05_count_reads.sh

# Differential expression
Rscript scripts/06_differential_expression.R

# Pathway analysis
Rscript scripts/07_pathway_analysis.R
```

---

## Viewing Results

### Quality Control

```bash
# Open MultiQC report
open results/qc/multiqc_report.html
```

### DEG Results

```bash
# View significant genes
head results/deg/deseq2_results_significant.csv
```

### Figures

All figures are saved as 300 DPI PNG files in `results/figures/`:

- `volcano_plot.png`
- `pca_plot.png`
- `ma_plot.png`
- `heatmap_top_degs.png`
- `GO_BP_dotplot.png`
- `KEGG_dotplot.png`

---

## Expected Output

After completion:

```
results/
├── qc/
│   └── multiqc_report.html       ← Quality metrics
├── aligned/
│   └── *.bam                     ← Aligned reads
├── counts/
│   └── count_matrix_clean.txt    ← Gene counts
├── deg/
│   ├── deseq2_results_significant.csv   ← DEGs
│   └── normalized_counts.csv
├── pathways/
│   ├── GO_biological_process.csv
│   └── KEGG_pathways.csv
└── figures/
    └── *.png                     ← All plots
```

---

## Troubleshooting

### R Package Issues

```r
# Update BiocManager
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install(version = "3.18")

# Install missing packages
BiocManager::install("DESeq2")
BiocManager::install("clusterProfiler")
```

### Download Issues

If SRA download fails, data can be manually downloaded from:
https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE79018

---

## Quick Reference

**Download data:**
```bash
bash scripts/01_download_data.sh
```

**Run analysis:**
```bash
bash scripts/run_pipeline.sh
```

**View results:**
```bash
open results/qc/multiqc_report.html
open results/figures/
```

That's it! 🧬
