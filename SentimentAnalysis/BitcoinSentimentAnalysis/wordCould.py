from os import path
from wordcloud import WordCloud

# Read the whole text.
d = path.dirname(__file__)
text = ' '
import glob
path = (path.join(d, 'bitcoinTweets_*.txt'))
files=glob.glob(path)
for file in files:
    f=open(file, 'r')
    text += (f.read())
    f.close()
'''
text.replace('::positive', '')
text.replace('::negative', '')
text.replace('::neutral', '')
'''
import re
text = re.sub('::positive', '', text)
text = re.sub('::neutral', '', text)
text = re.sub('::negative', '', text)
#print text


# Generate a word cloud image
wordcloud = WordCloud().generate(text)

# Display the generated image:
# the matplotlib way:
import matplotlib.pyplot as plt
plt.imshow(wordcloud, interpolation='bilinear')
plt.axis("off")

# lower max_font_size
wordcloud = WordCloud(max_font_size=40).generate(text)
plt.figure()
plt.imshow(wordcloud, interpolation="bilinear")
plt.axis("off")
plt.show()
