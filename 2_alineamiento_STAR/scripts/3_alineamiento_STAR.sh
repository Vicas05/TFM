#!/bin/bash
#SBATCH -J STAR_case1
#SBATCH -p thin
#SBATCH -c 40
#SBATCH -t 168:00:00
#SBATCH --mem=32G

# ==========================================
# Alineamiento de lecturas con STARsolo
# ==========================================

module load star/2.7.9a

GENOME_DIR="/ruta/genome_index"
MANIFEST="metadata/manifest_total.tsv"
OUT_DIR="./star_results"

mkdir -p $OUT_DIR

while IFS=$'\t' read -r SAMPLE READ1 READ2
do

    if [ -z "$SAMPLE" ]; then
        continue
    fi

    echo "Procesando muestra: $SAMPLE"

    SAMPLE_OUT_DIR="${OUT_DIR}/${SAMPLE}"

    mkdir -p $SAMPLE_OUT_DIR

    STAR \
        --genomeDir $GENOME_DIR \
        --runThreadN 40 \
        --soloType SmartSeq \
        --readFilesIn $READ1 $READ2 \
        --readFilesCommand zcat \
        --outFileNamePrefix ${SAMPLE_OUT_DIR}/ \
        --soloUMIdedup Exact \
        --soloStrand Unstranded \
        --outSAMattributes NH HI AS nM RG \
        --outSAMattrRGline ID:$SAMPLE SM:$SAMPLE \
        --outSAMtype BAM SortedByCoordinate

    echo "STAR finalizado para $SAMPLE"

done

echo "Alineamiento completado."