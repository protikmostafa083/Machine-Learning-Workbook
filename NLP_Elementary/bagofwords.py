# -*- coding: utf-8 -*-
"""
Created on Mon Sep 13 09:07:23 2021

@author: PROTIK
"""

import nltk

paragraph = '''
I have three visions for India. 

In 3000 years of our history, people from allover the world have come and invaded us, captured our lands, conquered our minds. From Alexander onwards. The Greeks, the Portuguese, the British, the French, the Dutch, all of them came and looted us, took over what was ours. Yet we have not done this to any other nation. We have not conquered anyone. We have not grabbed their land, their culture, their history tried to enforce our way of life on them. Why? Because we respect the freedom of others.

That is why my first vision is that of FREEDOM.

I believe that India got its first vision of this in 1857, when we started the war of independence. It is this freedom that we must protect and nurture and built on. If we are not free, no one will respect us.

My second vision for India is DEVELOPMENT.

For fifty years we have been a developing nation. It is time we see ourselves as a developed nation. We are among top 5 nations of the world in terms of GDP. We have 10 percent growth rate in most areas. Our poverty levels are falling, our achievements are being globally recognized today. Yet we lack the self-confidence to see ourselves as a developed nation, self reliant and self assured. Isn't this right?

I have a third vision. The India must stand up to the world. Because I believe that unless India stands up to the world, no one will respect us. Only strength respects strength. We must be strong not only as a military power but also as an economic power. Both must go hand-in-hand.

My good fortune was to have work with three great minds. Dr Vikram Sarabhai of the Dept. of space, Professor Satish Dhawan, who succeeded him, and Dr.Brahm Prakash, father of nuclear material. I was lucky to have worked with all three of them closely and consider this the great opportunity of my life.

I see four milestones in my career.
'''

#cleaning the text - remove comma, fullstop, other punctuation marks.
#the lemmatize, stem, lower the words.
#lowering the word is important or the upper and lower class will result having different words with same meaning
#re - regular expression
import re
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer
from nltk.stem import WordNetLemmatizer

#stemming & lemmatization
#stemmer = PorterStemmer()
lemmatization = WordNetLemmatizer()

sentences = nltk.sent_tokenize(paragraph)
#cleanedSentencesStemmer = []
cleanedSentencesLemmatization = []


#loop for stemming
for i in range(len(sentences)):
    words = re.sub('[^a-zA-Z]', ' ', sentences[i]) #replace all value except a-z or A-Z
    words = words.lower()
    words = words.split() #created a list
    #words = [stemmer.stem(word) for word in words if word not in set(stopwords.words('english'))]
    words = ' '.join(words)
    #cleanedSentencesStemmer.append(words)



# Loop for lemmatization
for i in range(len(sentences)):
    words = re.sub('[^a-zA-Z]', ' ', sentences[i])
    words = words.lower()
    words = words.split()
    words = [lemmatization.lemmatize(word) for word in words if word not in set(stopwords.words('english'))]
    words = ' '.join(words)
    cleanedSentencesLemmatization.append(words)


#creating Bag of Words
from sklearn.feature_extraction.text import CountVectorizer
cv = CountVectorizer()
X = cv.fit_transform(cleanedSentencesLemmatization).toarray()

















