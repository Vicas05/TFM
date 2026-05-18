#!/bin/bash

# ==========================================
# Generación de manifest.tsv para STARsolo
# ==========================================

# Uso:
# generar_manifest.sh /ruta/fastq prefijo output.tsv

FASTQ_DIR=$1
PREFIJO=$2
OUTPUT=$3

> "$OUTPUT"

for r1 in ${FASTQ_DIR}/${PREFIJO}*_R1_001.fastq.gz; do

    sample=$(basename "$r1" | cut -d "_" -f1-3)

    r2=${r1/_R1_001/_R2_001}

    echo -e "${sample}\t${r1}\t${r2}" >> "$OUTPUT"

done