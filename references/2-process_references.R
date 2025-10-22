# --- SCRIPT 2: PROCESAR REFERENCIAS ---

library(jsonlite)
library(dplyr)

# Carga la función generate_citations() y otras helpers
source("references/retrieve_helper.R") 

print("--- PASO 2: Iniciando procesamiento de datos ---")

# 1. Cargar datos desde archivos .rds (creados por Script 1)
print("Cargando datos desde archivos .rds...")
orcid_works_all <- readRDS("orcid_works_all.rds")
all_citations <- readRDS("all_citations.rds")
print("...datos cargados.")

# 2. Leer el CSV de checkeo (con tryCatch para la primera ejecución)
print("Leyendo orcid_works_check.csv...")
orcid_works_check <- tryCatch({
  read.csv("references/orcid_works_check.csv")
}, error = function(e) {
  print("Advertencia: No se encontró orcid_works_check.csv. Asumiendo primera ejecución.")
  data.frame() # Devuelve un dataframe vacío si no existe
})
print(paste("Se encontraron", nrow(orcid_works_check), "registros antiguos."))

# 3. Lógica de comparación
print(paste("Comparando registros antiguos (", nrow(orcid_works_check), ") con nuevos (", nrow(orcid_works_all), ")..."))
if (nrow(orcid_works_check) < nrow(orcid_works_all)){
  
  print("¡Nuevos registros encontrados! Generando archivos .bib...")
  # Esta función debe estar definida en retrieve_helper.R y usar
  # las variables 'orcid_works_all' y 'all_citations'
  generate_citations(orcid_works_all, all_citations) # Pasamos las variables a la función
  print("Added new citations") # Mensaje clave para el workflow
  
}else{
  
  print("No new records found.")
}

# 4. Escribir el nuevo CSV para la próxima ejecución
print("Actualizando references/orcid_works_check.csv...")
write.csv((orcid_works_all), "references/orcid_works_check.csv", row.names = F)

print("--- PASO 2: Procesamiento finalizado ---")

