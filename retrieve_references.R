
library(rorcid)

orcid_id = "0000-0003-2238-3674"

orcid_works_all <- works(orcid_id)

article_codes <- orcid_works_all[orcid_works_all$type == "journal-article",]$`put-code`

orcid_citations <- rorcid::orcid_citations(orcid_id)

article_citations <- orcid_citations[orcid_citations$put %in% article_codes,]$citation

write(article_citations, "pubs.bib")