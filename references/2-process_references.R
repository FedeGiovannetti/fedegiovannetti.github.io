
library(jsonlite)
library(dplyr)
source("references/retrieve_helper.R") 


# Load data from the fetch_orcid_data script
orcid_works_all <- readRDS("orcid_works_all.rds")
all_citations <- readRDS("all_citations.rds")

## Generate the citation files (.bib)
## conditional if "orcid_works_check.csv" 
## has less rows than the current orcid_works_all

print("Leyendo orcid_works_check.csv...")
orcid_works_check <- tryCatch({
  read.csv("references/orcid_works_check.csv")
}, error = function(e) {
  print("Advertencia: No se encontró orcid_works_check.csv. Asumiendo primera ejecución.")
  data.frame() # Devuelve un dataframe vacío si no existe
})



if (nrow(orcid_works_check) < nrow(orcid_works_all)){
  

  generate_citations(orcid_works_all, all_citations) # Pasamos las variables a la función
  print("Added new citations") # Mensaje clave para el workflow
  
}else{
  
  print("No new records found.")
}

# Store this df as it will be relevant to check for future updates
write.csv((orcid_works_all), "references/orcid_works_check.csv", row.names = F)



