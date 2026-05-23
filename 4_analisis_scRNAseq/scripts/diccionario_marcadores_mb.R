
# =========================================================
# Diccionario de marcadores del Mushroom Body (MB)
# =========================================================
# Objetivo:
# Convertir IDs de FlyBase (FBgn) a IDs compatibles
# con el objeto Seurat (Dmel-CGXXXX) y generar un
# diccionario con los nombres reales de los genes.
# =========================================================

# =========================================================
# 1. Conexión a Ensembl (Drosophila melanogaster)
# =========================================================

library(biomaRt)

mart <- useEnsembl(biomart = "genes", dataset = "dmelanogaster_gene_ensembl", mirror = "www")

## =========================================================
# 2. Lista de marcadores del Mushroom Body
# =========================================================
# IDs originales en formato FlyBase (FBgn)

mb_fbgn <- c(
  "FBgn0266137",  # Dop1R2 
  "FBgn0024944",  # Oamb 
  "FBgn0262737",	# mub 
  "FBgn00056727", # dac 
  "FBgn0043005",  # prt 
  "FBgn0033988", 	# pcs 
  "FBgn0034136", 	# DAT 
  "FBgn0287831", 	# speck 
  "FBgn0024277", 	# trio 
  "FBgn0267033", 	# mamo 
  "FBgn0000489", 	# Pka-C3 
  "FBgn0260943", 	# Rbp6 
  "FBgn0285926", 	# Imp 
  "FBgn0034535", 	# Immp2 
  "FBgn0262738", 	# norpA 
  "FBgn0004595", 	# pros 
  "FBgn0032840", 	# sNPF 
  "FBgn0027109", 	# NPF 
  "FBgn0000635", 	# Fas2 
  "FBgn0011656", 	# Mef2 
  "FBtp0006434",  # GAL4-Mef2.R 
  "FBgn0004652", 	# fru 
  "FBal0004157"   # fru
)

# =========================================================
# 3. Conversión FBgn -> CG + símbolo génico
# =========================================================

conversion <- getBM(
  attributes = c(
    "flybase_gene_id", # FBgn
    "flybase_annot_id", # CGXXXX
    "external_gene_name" # símbolo génico
  ),
  filters = "flybase_gene_id",
  values = mb_fbgn,
  mart = mart
)


# =========================================================
# 4. Limpieza de resultados
# =========================================================

# Eliminamos genes sin anotación CG
conversion_limpia <- conversion[!is.na(conversion$flybase_annot_id),]

# =========================================================
# 5. Generar IDs compatibles con Seurat
# =========================================================

# Añadir prefijo "Dmel-"
ids_dmel <- paste0("Dmel-", conversion_limpia$flybase_annot_id)
nombres_reales <- conversion_limpia$external_gene_name

# =========================================================
# 6. Crear diccionario 
# =========================================================
# Formato:
# names  -> IDs Dmel-CGXXXX
# values -> símbolos génicos

diccionario_mb <- setNames(nombres_reales, ids_dmel)

# =========================================================
# 7. Extraer lista de IDs para análisis posteriores
# =========================================================
mb_markers <- names(diccionario_mb)

