# Sentiment-Analysis-Thesis
Files related to my economic thesis on sentiment analysis of news articles. 

cleanNYTvader.py - This file takes text files of New York Times articles downloaded from Lexis Nexis Database. I download the articels in PDF format from the 
database and convert to text using the pdf2text file also contained in this repository. Using the open source Vader package articles are given a sentiment score
taken as an average of individual sentence sentiments.

pdf2txt.R - This file simply converts a PDF file to a text file

prelimAnalysis.R - Given the senteiment of each NYT articles from cleanNYTvader.py this program aggregates scores daily and monthly. Z scores are given to both 
daily and monthly scores to normalize data. This file also takes consumer sentiment data from the University of Michigan. This data is also normalized with a Z 
score and compared to monthly data. Graphs of news sentiment vs time, including volume of news articles are produced. 
