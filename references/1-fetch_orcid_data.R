# --- SCRIPT 1: OBTENER DATOS DE ORCID ---

library(rorcid)
library(dplyr)

print("--- PASO 1: Iniciando fetch de ORCID ---")

orcid_id = "0000-0003-2238-3674"

# 1. Obtener 'works'
# La autenticación (ORCID_TOKEN) es usada aquí
print("Obteniendo works()...")
orcid_works_all <- works(orcid_id) %>% 
  as.data.frame() %>% 
  select('put-code', type, title.title.value, url.value, 'publication-date.year.value', 'journal-title.value')
print("... works() obtenidos.")

# 2. Obtener 'citations'
# La autenticación (ORCID_TOKEN) es usada aquí
print("Obteniendo orcid_citations()...")
all_citations <- rorcid::orcid_citations(orcid_id)
print("... citations obtenidas.")

# 3. Guardar en archivos temporales
saveRDS(orcid_works_all, file = "orcid_works_all.rds")
saveRDS(all_citations, file = "all_citations.rds")

print("--- PASO 1: Datos de ORCID guardados en .rds ---")