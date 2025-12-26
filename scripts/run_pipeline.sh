#!/bin/bash
# Complete RNA-seq analysis pipeline

set -e

echo "========================================"
echo "  RNA-seq Analysis Pipeline"
echo "========================================"
echo ""

START_TIME=$(date +%s)

# Run pipeline steps
echo "[1/7] Downloading data..."
bash scripts/01_download_data.sh

echo ""
echo "[2/7] Quality control..."
bash scripts/02_quality_control.sh

echo ""
echo "[3/7] Trimming reads..."
bash scripts/03_trim_reads.sh

echo ""
echo "[4/7] Aligning to genome..."
bash scripts/04_align_reads.sh

echo ""
echo "[5/7] Counting genes..."
bash scripts/05_count_reads.sh

echo ""
echo "[6/7] Differential expression..."
Rscript scripts/06_differential_expression.R

echo ""
echo "[7/7] Pathway analysis..."
Rscript scripts/07_pathway_analysis.R

# Generate summary
echo ""
echo "Generating summary..."

cat > results/analysis_summary.txt << EOF
RNA-seq Analysis Summary
Analysis Date: $(date)

Dataset: GSE79018
Organism: Mouse (Mus musculus)
Design: Dnmt1 KO vs Control (2 replicates)

Results:
├── QC: results/qc/
├── Alignment: results/aligned/
├── Counts: results/counts/
├── DEGs: results/deg/
├── Pathways: results/pathways/
└── Figures: results/figures/

Key Files:
- DEG Results: results/deg/deseq2_results_significant.csv
- Normalized Counts: results/deg/normalized_counts.csv
- GO Enrichment: results/pathways/GO_biological_process.csv
- KEGG Pathways: results/pathways/KEGG_pathways.csv

Figures (300 DPI):
- volcano_plot.png
- pca_plot.png
- ma_plot.png
- heatmap_top_degs.png
- GO_BP_dotplot.png
- KEGG_dotplot.png
EOF

cat results/analysis_summary.txt

# Calculate runtime
END_TIME=$(date +%s)
RUNTIME=$((END_TIME - START_TIME))
HOURS=$((RUNTIME / 3600))
MINUTES=$(((RUNTIME % 3600) / 60))

echo ""
echo "========================================"
echo "✓ Pipeline Complete!"
echo "========================================"
echo ""
echo "Runtime: ${HOURS}h ${MINUTES}m"
echo ""
echo "View results:"
echo "  QC: results/qc/multiqc_report.html"
echo "  DEGs: results/deg/deseq2_results_significant.csv"
echo "  Figures: results/figures/"
echo ""
