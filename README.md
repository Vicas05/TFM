# Estudio transcriptómico de la memoria en *Drosophila melanogaster*
Este repositorio contiene el proyecto desarrollado como parte del Trabajo de Fin de Máster del Máster de Bioinformática y Biología Computacional en la Universidad Autónoma de Madrid (curso 2024-2026).

El presente trabajo tiene como objetivo general identificar diferencias en los perfiles transcripcionales asociados a distintos paradigmas de aprendizaje social tanto entre poblaciones neuronales como entre condiciones experimentales, y evaluar la posible conservación de mecanismos moleculares asociados a la memoria, utilizando Drosophila melanogaster. 

--- 

## Objetivos específicos
1.	Filtrado y purificación de datos obtenidos por scRNA-seq utilizando dos paradigmas de aprendizaje social, sumado a la reactivación de memoria.
2.	Identificación y caracterización de las poblaciones celulares presentes en el dataset, con especial interés en las neuronas pertenecientes al MB y sus distintos subtipos neuronales.
3.	Análisis de expresión diferencial, tanto a nivel global como específico de subpoblaciones celulares, centrado en los paradigmas de condicionamiento por cortejo (CC_T) y condicionamiento social (SC_T). 
4.	Comparación con estudios transcriptómicos previos, realizados tanto en mosca como en ratón. 

---

## Estructura del trabajo

```
├───1_control_calidad
│   ├───results_multiqc
│   │   │   multiqc_report.html
│   │   └───multiqc_data
│   └───script
│           QC.sh
│
├───2_alineamiento_STAR
│   ├───archivos_manifests
│   │       manifest_596.tsv
│   │       manifest_597.tsv
│   │       manifest_598.tsv
│   │       manifest_743.tsv
│   │       manifest_744.tsv
│   │       manifest_900.tsv
│   │       manifest_total.tsv
│   │
│   └───scripts
│           1_generar_manifest.sh
│           2_indice_STAR.sh
│           3_alineamiento_STAR.sh
│
├───3_HTSeq_count
│   ├───estadisticas_STAR
│   │       star_stats.csv
│   └───script
│           HTSeq_count.sh
│
├───4_analisis_scRNAseq
│   │   Analisis_scRNAseq.html
│   │   Analisis_scRNAseq.qmd
│   ├───Analisis_scRNAseq_files
│   │
│   ├───objetos
│   │       diccionario_marcadores_MB.rds
│   │       meta_genes.rds
│   │       seurat_filtered.rds
│   │       seurat_obj.rds
│   │
│   ├───scripts   # scripts adicionales
│   │       diccionario_marcadores_mb.R
│   │       diccionario_nombres_genicos.R
│   │
│   └───tablas
│           star_stats.csv
│           Total_genes.xlsx
│
└───_figuras_generadas
```

---

## Herramientas y entornos
El proyecto se desarrolló en un entorno Linux utilizando scripts en Bash y análisis posteriores en R mediante documentos Quarto (`.qmd`).

#### Preprocesado y alineamiento
- FastQC (v12.1)
- MultiQC (v1.31)
- STAR (v2.7.9a)
- Htseq-count (v2.0.2)

#### Análisis transcriptómico
- R (v4.4.1)
- Seurat (v5)

El resto de dependencias de R utilizadas en el trabajo se pueden encontrar en el archivo `requirements_R.txt`.

---

## Ejecutar el proyecto

1. Clonar el repositorio

```bash
git clone URL
```

2. Instalar paquetes de R

```r
packages <- readLines("requirements_R.txt")
install.packages(packages)
```

3. Ejecutar los scripts en orden:

   - `1_control_calidad`
       - `QC.sh`
   - `2_alineamiento_STAR`
       - `1_generar_manifest.sh`
       - `2_indice_STAR.sh`
       - `3_alineamiento_STAR.sh`
    - `3_HTSeq_count`
      - `HTSeq_count.sh`
    - `4_analisis_scRNAseq`
      - `Analisis_scRNAseq.qmd`
  
---  


