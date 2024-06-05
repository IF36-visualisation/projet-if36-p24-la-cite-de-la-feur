library(readr)
library(ggplot2)
library(wordcloud)
library(RColorBrewer)
library(stringr)

# charger les données
rm(list=ls())
df <- df <- read_csv("../../data/data_1_200000_noDuplicates.csv")

# exemple pour retirer les langages du premier dépôt
# text <- df$languages[1]
# pattern <- "'name': '[a-zA-Z]+"
# matching <- str_extract_all(text, pattern)
# langages <- substr(matching[[1]], start = 10, stop = 1000)
# print(langages)

# Appliqué à tous les dépôts
text <- df$languages
pattern <- "'name': '[^']+"
matching <- str_extract_all(text, pattern)
langages <- mapply(matching,
				   FUN = substr,
				   start = 10,
				   stop = 1000)

# Convertir en une unique liste
langagesVec <- unlist(langages)
word_freqs <- table(langagesVec) %>% as.data.frame()
colnames(word_freqs) <- c("word", "freq")

set.seed(1234) # for reproducibility
windows()
wordcloud(words = word_freqs$word, freq = word_freqs$freq, min.freq = 1,
		  max.words=200, random.order=FALSE, rot.per=0.35,
		  colors=brewer.pal(8, "Dark2"))

set.seed(1234) # for reproducibility
windows()
wordcloud(
	words = word_freqs$word,
	freq = word_freqs$freq,
	min.freq = 1,
	max.words=200,
	random.order=FALSE,
	color=brewer.pal(12, "Paired"),
	random.color = TRUE,
	fixed.asp = TRUE
)