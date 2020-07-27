library(rvest)
library(tidyverse)

#Uses Latest Headlines for New Zealand Google News
HeadlinesLink <- xml2::read_html("https://news.google.com/topics/CAAqJggKIiBDQkFTRWdvSUwyMHZNRFZxYUdjU0FtVnVHZ0pPV2lnQVAB?hl=en-NZ&gl=NZ&ceid=NZ%3Aen")

GoogleNewsHeadlines <- HeadlinesLink %>%
  html_nodes('.DY5T1d') %>%
  html_text()

Publisher <- HeadlinesLink %>%
  html_nodes('a.wEwyrc.AVN2gc.uQIVzc.Sksgp') %>%
  html_text()

#Uses New Zealand Headlines for New Zealand Google News
NZHeadlinesLink <- xml2::read_html("https://news.google.com/topics/CAAqJggKIiBDQkFTRWdvSUwyMHZNRFZxYUdjU0FtVnVHZ0pPV2lnQVAB/sections/CAQiUkNCQVNOd29JTDIwdk1EVnFhR2NTQldWdUxVZENHZ0pPV2lJUENBUWFDd29KTDIwdk1HTjBkMTlpS2c4S0RSSUxUbVYzSUZwbFlXeGhibVFvQUEqLggAKioICiIkQ0JBU0ZRb0lMMjB2TURWcWFHY1NCV1Z1TFVkQ0dnSk9XaWdBUAFQAQ?hl=en-NZ&gl=NZ&ceid=NZ%3Aen")

NZHeadlines <- NZHeadlinesLink %>%
  html_nodes('.DY5T1d') %>%
  html_text()

NZPublisher <- NZHeadlinesLink %>%
  html_nodes('a.wEwyrc.AVN2gc.uQIVzc.Sksgp') %>%
  html_text()

GoogleNewsHeadlinesDF <- tibble(Headline = as.character(GoogleNewsHeadlines), Publisher = as.character(Publisher), Date = as.character(Sys.Date()))

#Just in case there are duplicated articles
GoogleNewsHeadlinesDF <- GoogleNewsHeadlinesDF %>% 
  distinct(Headline, .keep_all = TRUE)

NZHeadlinesDF <- tibble(Headline = as.character(NZHeadlines), Publisher = as.character(NZPublisher), Date = as.character(Sys.Date()))

#Just in case there are duplicated articles
NZHeadlinesDF <- NZHeadlinesDF %>% 
  distinct(Headline, .keep_all = TRUE)

write.table(GoogleNewsHeadlinesDF, file = "LatestHeadlines.csv", append = TRUE, sep = ",", row.names = F, col.names = F)
write.table(NZHeadlinesDF, file = "NZHeadlines.csv", append = TRUE, sep = ",", row.names = F, col.names = F)