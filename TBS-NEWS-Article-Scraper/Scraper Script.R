#Sets the system locale to Japnaese, MUST BE RUN FIRST
Sys.setlocale("LC_CTYPE", "Japanese")
library(rvest)
library(tidyverse)
library(tokenizers)
library(readr)



#Gets news article
news <- xml2::read_html(readline(prompt = "Enter URL (tbs):"))

#test case "https://news.tbs.co.jp/newseye/tbs_newseye3750343.html"

data <- news %>%
  html_nodes(".md-mainArticle p") %>%
  html_text()

#Splits sentence at each full stops, paragraphs, etc
news_data <- unlist(tokenize_sentences(data))

#Remove duplicated sentences
li1 <- lapply(news_data, function(x) unique(x))
i1 <- !(duplicated(li1)|duplicated(li1, fromLast = TRUE))
news_data <- news_data[i1]

dat <- as.data.frame(news_data)

#lapply(news_data, write, "Sentences.txt", append=TRUE)
write_csv(dat, "Sentences.txt", append=TRUE)

#Sets the system locale back to system default
Sys.setlocale("LC_CTYPE", "")
