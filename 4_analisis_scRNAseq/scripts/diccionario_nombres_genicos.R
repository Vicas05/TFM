
# =========================================================
# Diccionario de nombres génicos
# =========================================================
# Objetivo:
# Asociar los IDs internos de FlyBase (Dmel-CGXXXX)
# con los símbolos génicos oficiales utilizando biomaRt.
# =========================================================

# =========================================================
# 1. Conexión a Ensembl (Drosophila melanogaster)
# =========================================================

library(biomaRt)

# Conexión al servidor de Ensembl usando un mirror estable
ensembl <- useEnsembl(biomart = "genes", 
                      dataset = "dmelanogaster_gene_ensembl",
                      mirror = "www")


# =========================================================
# 2. Extraer IDs génicos del objeto Seurat
# =========================================================

# Cargar el objeto Seurat 
seurat_filtered <- readRDS("objetos/seurat_filtered.rds")

# IDs originales presentes en el objeto
gene_names <- rownames(seurat_filtered) 

# Eliminación del prefijo "Dmel-" para que coincida con FlyBase
gene_names_clean <- gsub("Dmel-", "", gene_names) 


# =========================================================
# 3. Obtener símbolos génicos desde Ensembl
# =========================================================

tabla_conversion <- getBM(attributes = c('flybase_annot_id', 'external_gene_name'),
                          filters = 'flybase_annot_id',
                          values = gene_names_clean,
                          mart = ensembl)


# =========================================================
# 4. Emparejar IDs con símbolos génicos
# =========================================================

indices <- match(gene_names_clean, tabla_conversion$flybase_annot_id)
nombres_finales <- tabla_conversion$external_gene_name[indices]

# =========================================================
# 5. Limpieza y control de errores
# =========================================================

# Sustituir genes no encontrados (NA)
nombres_finales[is.na(nombres_finales)] <- gene_names[is.na(nombres_finales)]

# Sustituir nombres vacíos ("")
nombres_finales[nombres_finales == ""] <- gene_names[nombres_finales == ""]

# Forzar nombres únicos
nombres_finales <- make.unique(as.character(nombres_finales))

# =========================================================
# 6. Comprobación 
# =========================================================

# Verificar que la conversión es correcta
head(data.frame(
  Original = gene_names[1:10],
  CG = gene_names_clean[1:10],
  Symbol = nombres_finales[1:10]
))

# =========================================================
# 7. Crear tabla de metadatos génicos
# =========================================================

meta_genes <- data.frame(
  Symbol = nombres_finales,
  row.names = gene_names
)

# =========================================================
# 8. Añadir metadatos al assay RNA
# =========================================================

seurat_filtered[["RNA"]] <- AddMetaData(
  object = seurat_filtered[["RNA"]],
  metadata = meta_genes
)

# Verificación final
head(seurat_filtered[["RNA"]][[]])


# =========================================================
# 9. Comprobación manual de genes concretos
# =========================================================

genes_test <- c("Dmel-CG1864", "Dmel-CG4463", "Dmel-CG4183")

tabla_genes <- seurat_filtered[["RNA"]][[]]

tabla_genes[genes_test, "Symbol", drop = FALSE]
