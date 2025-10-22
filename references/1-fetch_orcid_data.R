
library(rorcid)
library(dplyr)

#### This script contains the code for retrieving references
#### from articles, conferences and chapters from Orcid

## My Orcid id

orcid_id = "0000-0003-2238-3674"

# Retrieve all works

orcid_works_all <- works(orcid_id) %>% 
  
  # I simplify a little this data as I really don't need so much columns
  as.data.frame() %>% 
  select('put-code', type, title.title.value, url.value, 'publication-date.year.value', 'journal-title.value')


# Retrieve all citations (this is a different way of accessing the data
# and gives more-formatted citations)

all_citations <- rorcid::orcid_citations(orcid_id)


# save all in temporary files for github actions
saveRDS(orcid_works_all, file = "orcid_works_all.rds")
saveRDS(all_citations, file = "all_citations.rds")
