
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


generate_citations <- function(){
  
  ## generate_citations takes the orcid_works_all and the all_citations
  ## objects and writes three references files: 
  ## "pubs.bib" containing publications references
  ## "conferences.bib" containing conference references
  ## "books.bib" containing book chapters references
  
  #### Article citations ####
  
  article_codes <- orcid_works_all[orcid_works_all$type == "journal-article",]$`put-code`
  
  article_citations <- all_citations[all_citations$put %in% article_codes,]$citation
  
  write(article_citations, "references/pubs.bib")
  
  
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
  
  write(conference_citations, "references/conferences.bib")
  
  
  #### Book Chapters ####
  
  book_codes <- orcid_works_all[orcid_works_all$type == "book-chapter",]$`put-code`
  
  book_citations <- all_citations[all_citations$put %in% book_codes,]$citation
  
  write(book_citations, "references/books.bib")
  
  
  
}
