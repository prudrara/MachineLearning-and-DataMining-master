The twitter API allows us to download only 1 weeks worth of tweets. The API created by [Jefferson Henrique](https://github.com/Jefferson-Henrique) allows us to download old tweets using various factors. 

I modified the Exporter.py to download the tweets to text files and added the sentiment factor to the code. The output files have the tweet along with its sentiment. 

The download is done with the help of a shell script bitcoinTweets.sh. This script can be modified to download tweets based on different times and search queries. 

The downloaded data is converted to a dataframe using pandas. The output figure shows the types of tweets downloaded.
