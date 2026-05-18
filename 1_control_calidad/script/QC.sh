#!/bin/bash

# ==========================================
# Control de calidad para los archivos crudos FASTQ
# FastQC v0.12.1
# MultiQC v1.31
# ==========================================

# Creamos los directorios de salida
mkdir -p results_fastqc
mkdir -p results_multiqc

# Contamos los archivos FASTQ
ls *.fastq.gz | wc -l

# Contamos las muestras
ls *.fastq.gz | cut -d "_" -f1 | sort | uniq -c

# Corremos FastQC
fastqc *.fastq.gz -o results_fastqc/

# Agrupamos los informes con MultiQC
multiqc results_fastqc/ -o results_multiqc/