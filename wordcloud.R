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
consumerKey <- "your consumerKey"
consumerSecret <- "your consumerSecret"
accessToken <- "your accessToken"
accessTokenSecret <- "your accessTokenSecret"

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




