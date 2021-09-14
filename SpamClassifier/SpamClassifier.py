# -*- coding: utf-8 -*-
"""
Created on Tue Sep 14 10:32:57 2021

@author: PROTIK
"""
# Import and read data from dataset

import pandas as pd

messages = pd.read_csv('smsspamcollection/SMSSpamCollection', sep='\t', names=['label', 'message'])


# Data cleaning and Preprocessing
import re                                                 # Regular Expression
from nltk.stem import PorterStemmer
from nltk.corpus import stopwords

# Creating Stemming Object
stemmer = PorterStemmer()               
cleanedSentence = []

# Cleaning Process
for i in range(0, len(messages)):
    sents = re.sub('[^a-zA-Z]', ' ', messages['message'][i])
    sents = sents.lower()
    sents = sents.split()
    sents = [stemmer.stem(word) for word in sents if word not in set(stopwords.words('english'))]
    sents = ' '.join(sents)
    cleanedSentence.append(sents)
    
# implementing Bag of Words Models
from sklearn.feature_extraction.text import CountVectorizer
cv = CountVectorizer(max_features = 5000)                  # max_feature = top number of columns I want to choose
X = cv.fit_transform(cleanedSentence).toarray()


# Creating Dummy Variable for another column - Class
y = pd.get_dummies(messages['label'])
y = y.iloc[:, 1].values


# Train-Test Split
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size= 0.2, random_state=0)


# Training Naive Bayes Classifier
from sklearn.naive_bayes import MultinomialNB
spam_model = MultinomialNB().fit(X_train, y_train)

y_pred = spam_model.predict(X_test)


# Comparing
from sklearn.metrics import confusion_matrix
conf_mat = confusion_matrix(y_test, y_pred)

#accuracy score
from sklearn.metrics import accuracy_score
acc = accuracy_score(y_test, y_pred)

print(acc)











