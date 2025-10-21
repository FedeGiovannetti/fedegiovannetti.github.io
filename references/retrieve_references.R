
library(rorcid)
library(jsonlite)


#### This script contains all the code for retrieving references
#### from articles, conferences and chapters from Orcid


## json_to_bibtex_inproceedings fixes some problems related
## to how orcid_citations delivers citations with no associated doi

json_to_bibtex_inproceedings <- function(json_text){
  
  entry <- fromJSON(json_text)
  
  # Convert manually to BibLaTeX format
  bib_entry <- sprintf("@inproceedings{%s,\n  author = {%s},\n  year = {%s},\n  title = {%s},\n  booktitle = {%s}\n}",
                       entry$id,
                       sub("Federico Giovannetti and ", "", entry$author$literal),  # for some reason my name is twice so I take it away
                       entry$issued$`date-parts`[[1]][1],
                       entry$title,
                       entry$`container-title`)
  
  return(bib_entry)
  
  
}


## My Orcid id

orcid_id = "0000-0003-2238-3674"

# Retrieve all works and citations

orcid_works_all <- works(orcid_id)

all_citations <- rorcid::orcid_citations(orcid_id)


#### Article citations ####

article_codes <- orcid_works_all[orcid_works_all$type == "journal-article",]$`put-code`

article_citations <- all_citations[all_citations$put %in% article_codes,]$citation

write(article_citations, "pubs.bib")


#### Conference citations ####

conference_codes <- orcid_works_all[orcid_works_all$type == "conference-poster" | orcid_works_all$type == "conference-paper",]$`put-code`

## Fix citations with no associated doi

conference_citations_df <- all_citations %>% 
  filter(put %in% conference_codes) %>% 
  rowwise() %>% 
  mutate(citation = ifelse(is.na(ids), 
                           json_to_bibtex_inproceedings(citation),
                           citation)
         )

conference_citations <- conference_citations_df$citation

write(conference_citations, "conferences.bib")


#### Book Chapters ####

book_codes <- orcid_works_all[orcid_works_all$type == "book-chapter",]$`put-code`

book_citations <- all_citations[all_citations$put %in% book_codes,]$citation

write(book_citations, "books.bib")



