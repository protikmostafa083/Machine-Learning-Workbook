# -*- coding: utf-8 -*-
"""
Created on Sat Sep 11 10:16:20 2021

@author: PROTIK
"""

import nltk



paragraph = """
Chutes and Ladders is a game based on complete random chance. 
There is no strategy involved whatsoever. 
Your pawn movement completely relies on what number you spin on every turn. 
While this makes it a rather boring game for some, 
it provides those interested in data science with a solid foundation for a game simulator. 
This game is extremely simple. On your turn, you spin a dial and get a number between 1 and 6. 
Starting from space 0, you move your pawn the amount of spaces you were granted by the dial.
"""

#SENTENCES
sentence = nltk.sent_tokenize(paragraph)
words = nltk.word_tokenize(paragraph)