
library(rorcid)
library(jsonlite)
library(dplyr)
source("references/retrieve_helper.R")


#### This script contains all the code for retrieving references
#### from articles, conferences and chapters from Orcid


## My Orcid id

orcid_id = "0000-0003-2238-3674"

# Retrieve all works and citations

orcid_works_all <- works(orcid_id) %>% 
  
  # I simplify a little this data as I really don't need so much columns
  as.data.frame() %>% 
  select('put-code', type, title.title.value, url.value, 'publication-date.year.value', 'journal-title.value')

# Retrieve all citations (this is a different way of accessing the data
# and gives more-formatted citations)

all_citations <- rorcid::orcid_citations(orcid_id)



## Generate the citation files (.bib)
## conditional if "orcid_works_check.csv" 
## has less rows than the current orcid_works_all

orcid_works_check <- tryCatch({
  read.csv("references/orcid_works_check.csv")
}, error = function(e) {
  print("Advertencia: No se encontró orcid_works_check.csv. Asumiendo primera ejecución.")
  data.frame() # Devuelve un dataframe vacío
})

if (nrow(orcid_works_check) < nrow(orcid_works_all)){
  
  generate_citations()
  print("Added new citations")
  
}else{
  
  print("No new records found.")
  
}

# Store this df as it will be relevant to check for future updates

write.csv((orcid_works_all), "references/orcid_works_check.csv", row.names = F)

