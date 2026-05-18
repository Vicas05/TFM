#!/bin/bash
#SBATCH -J HTSeq_count
#SBATCH -p thin
#SBATCH -c 1
#SBATCH -t 168:00:00
#SBATCH --mem=32G
#SBATCH -o slurm_htseq-%j.out

# ==========================================
# Cuantificación de genes con HTSeq-count
# ==========================================

# Cargar módulo
module load htseq/2.0.2

# Definir rutas
MANIFEST="metadata/manifest_total.tsv"
GTF_FILE="/ruta/genomic_final.gtf"
BASE_DIR="./star_results"
COUNTS_DIR="./HTSeq_counts"

# Crear directorio de salida
mkdir -p $COUNTS_DIR

echo "Iniciando cuantificación con HTSeq-count..."

# ==========================================
# Bucle principal
# ==========================================

while IFS=$'\t' read -r SAMPLE READ1 READ2
do

    # Saltar líneas vacías
    if [ -z "$SAMPLE" ]; then
        continue
    fi

    # Archivo BAM generado por STAR
    BAM_FILE="${BASE_DIR}/${SAMPLE}/Aligned.sortedByCoord.out.bam"

    # Archivo de salida
    COUNTS_OUT_FILE="${COUNTS_DIR}/${SAMPLE}_counts.tsv"

    # Comprobar si existe el BAM
    if [ ! -f "$BAM_FILE" ]; then
        echo "Archivo no encontrado: $BAM_FILE"
        continue
    fi

    # Evitar repetir conteos ya generados
    if [ -f "$COUNTS_OUT_FILE" ]; then
        echo "Conteos ya existentes para $SAMPLE"
        continue
    fi

    echo "Procesando muestra: $SAMPLE"

    # ==========================================
    # HTSeq-count
    # ==========================================

    htseq-count \
        --format bam \
        --order pos \
        --mode intersection-strict \
        --stranded reverse \
        --minaqual 1 \
        --type gene \
        --idattr gene_id \
        $BAM_FILE \
        $GTF_FILE \
        > $COUNTS_OUT_FILE

    echo "Conteo finalizado para $SAMPLE"

done < $MANIFEST

echo "Cuantificación completada."

# ==========================================
# Extracción de estadísticas de alineamiento
# ==========================================

echo "Generando tabla de estadísticas STAR..."

STATS_FILE="${BASE_DIR}/star_stats.csv"

# Crear cabecera del CSV
echo "SampleID,Input_Reads,Uniquely_Mapped_Percent,Multimapped_Percent" > $STATS_FILE

# Recorrer carpetas de resultados STAR
for folder in ${BASE_DIR}/*
do

    if [ -d "$folder" ] && [ -f "$folder/Log.final.out" ]; then

        SAMPLE=$(basename "$folder")

        # Número total de reads
        INPUT=$(grep "Number of input reads" "$folder/Log.final.out" | awk '{print $6}')

        # Porcentaje de reads alineadas de forma única
        UNIQUE=$(grep "Uniquely mapped reads %" "$folder/Log.final.out" | awk '{print $6}' | tr -d '%')

        # Porcentaje de reads multimapeadas
        MULTI=$(grep "% of reads mapped to multiple loci" "$folder/Log.final.out" | awk '{print $9}' | tr -d '%')

        # Guardar resultados
        echo "${SAMPLE},${INPUT},${UNIQUE},${MULTI}" >> $STATS_FILE

    fi

done

echo "Tabla star_stats.csv generada correctamente."