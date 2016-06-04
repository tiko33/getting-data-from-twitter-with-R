#required packages
#Sys.setenv(LANG = "en")
install.packages(c("twitterR","ROAuth","RCurl","tm","wordcloud","SnowballC"))
install.packages("SnowballC")
library(SnowballC)
library(twitteR)
library(ROAuth)
library(RCurl)
library(tm)
library(wordcloud)
ls()
#twitter authentication
consumerKey <- "tT7e2vSIAv8mzOFjKnedhau0D"
consumerSecret <- "PWgfDoG24U7VUiFCHnLarNz0RmQbjPEofywxxOHcp1eOI6dotI"
accessToken <- "2608779027-8NQT6mu3Kf8hwKZTAuPr9ua3wpS43cs02UqeMWZ"
accessTokenSecret <- "V3jfYIVnbztp9OlbLlDUOTz2bRNJrOMBLe3D3Old6JVpb"

twitteR::setup_twitter_oauth(consumerKey,consumerSecret,accessToken,accessTokenSecret)

#retrive tweets from twitter
tweets=searchTwitter("machine+learning",lang = "en",n=1200,resultType = "recent")
class(tweets)
head(tweets)
#converting list to vector
tweets_text=sapply(tweets,function(x) x$getText())
str(tweets_text)
#creates corpus from vector of tweets
tweets_corpus=Corpus(VectorSource(tweets_text))
#if you get the below error
#In mclapply(content(x), FUN, ...) :
#  all scheduled cores encountered errors in user code
#run this step if you get the error:
tweets_corpus <- tm_map(tweets_corpus,
                   content_transformer(function(x) iconv(x, to='UTF-8-MAC', sub='byte')),
                   mc.cores=1)
inspect(tweets_corpus[100])
#cleaning
tweets_clean=tm_map(tweets_corpus,removePunctuation,lazy = TRUE)
tweets_clean=tm_map(tweets_clean,content_transformer(tolower),lazy = T)
tweets_clean=tm_map(tweets_clean,removeWords,stopwords("english"),lazy = T)
tweets_clean=tm_map(tweets_clean,removeNumbers,lazy = T)
tweets_clean=tm_map(tweets_clean,stripWhitespace,lazy = T)
tweets_clean=tm_map(tweets_clean,removeWords,c("machine","learning"),lazy = T)
#wordcloud play with parameters
wordcloud(tweets_clean)
wordcloud(tweets_clean,random.order = F,scale = c(3,0.5), colors = rainbow(50))




