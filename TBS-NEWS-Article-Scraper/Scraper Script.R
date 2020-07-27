#Sets the system locale to Japnaese, MUST BE RUN FIRST
Sys.setlocale("LC_CTYPE", "Japanese")
library(rvest)
library(tidyverse)
library(tokenizers)
library(readr)



#Gets news article
#news <- xml2::read_html(readline(prompt = "Enter URL (tbs):"))
#news <- xml2::read_html("https://news.tbs.co.jp/newseye/tbs_newseye3849504.html")

#test case "https://news.tbs.co.jp/newseye/tbs_newseye3750343.html"
#konbini <- read_csv("C:/Users/William/Desktop/texts/konbini.txt", 
                    #col_names = FALSE)
konbini <- read_csv("C:/Users/William/Desktop/new 1.txt", 
                  col_names = FALSE)
View(new_1)
#data <- news %>%
  #html_nodes(".md-mainArticle p") %>%
  #html_text()

test1 <- as.vector(t(konbini))
View(test1)

#Splits sentence at each full stops, paragraphs, etc
news_data <- unlist(tokenize_sentences(test1))

View(news_data)

#Remove duplicated sentences
li1 <- lapply(news_data, function(x) unique(x))
i1 <- !(duplicated(li1)|duplicated(li1, fromLast = TRUE))
news_data <- news_data[i1]

dat <- as.data.frame(news_data)



#lapply(news_data, write, "Sentences.txt", append=TRUE)
write_csv(dat, "Sentences.txt", append=TRUE)

#Sets the system locale back to system default
Sys.setlocale("LC_CTYPE", "")
