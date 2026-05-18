#!/bin/bash

# ==========================================
# Generación del índice del genoma para STAR
# ==========================================

# Genoma de referencia:
# Drosophila melanogaster BDGP6.46
# Fuente:
# https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001215.4/

STAR \
  --runThreadN 4 \
  --runMode genomeGenerate \
  --genomeDir ./genome_index \
  --genomeFastaFiles Drosophila_melanogaster.BDGP6.46.dna.toplevel.fa \
  --sjdbGTFfile Drosophila_melanogaster.BDGP6.46.111.gtf \
  --sjdbOverhang 150
