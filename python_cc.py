#!/usr/bin/python3 
import re

def check_valid_cc(card_num):
    correct='^([456][0-9]{3})-?([0-9]{4})-?([0-9]{4})-?([0-9]{4})$'
    output_cc = re.match(correct,card_num)
    if output_cc != None:
      print("cc is valid")
    else:
      print("cc is invalid")
    return output_cc

card_num = input()
t=check_valid_cc(card_num)
