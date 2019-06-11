#!/usr/bin/python3 

# import re regular expression for checking correct credit card numbers 
import re 

# function is defined that that card number as parameters 

def check_valid_cc(card_num):
    correct='^([456][0-9]{3})-?([0-9]{4})-?([0-9]{4})-?([0-9]{4})$'
#re.match is use to compare correct format for cards and card number
    output_cc = re.match(correct,card_num)
    if output_cc != None:
      print("cc is valid")
    else:
      print("cc is invalid")
    return output_cc
# card_num to store credit card number, asking from user
card_num = input()
t=check_valid_cc(card_num)
