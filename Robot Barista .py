#!/usr/bin/env python
# coding: utf-8

# #creating a robot barista that asks for the customer's name using the input function and prints a personalized greeting.

# # hello, welcome to maan coffee!!")

# In[1]:


name = input("what is your name? ")


# In[2]:


#in the cell below I want to restrict thos who enter my coffee shop,
#specially ben, patricia and loki becouse they are evil!!
#but even evil people can enter if they have done 5 or more good deeds that day! 


# In[3]:


if name == "ben" or name == "patricia" or name == "loki" :
    evil_status = input("Are you evil?\n")
    good_deeds = int(input("how many good deeds have you done today? \n"))
    if evil_status == "yes" and good_deeds  < 5 :
        print("You're not welcome here " + name + " GET OUT OF HERE")
        exit()
    else:
        print("So you are one of the good ones, come in.")
else:
    print("Hello " + name + ", thank you so much for coming in today!\n\n")


# In[ ]:


print("hello " + name + " thank you so much for coming in today! ")


# In[ ]:


#coffee menu


# In[ ]:


menu = "black coffe, espresso, latte, cappucino, frappuccino "


# In[ ]:


#ask the customer what they would like from the menu
#and store it in the variable order


# In[ ]:


order = input(name + ", what would you like from our menu today? Here is what we are serving.\n" + menu)


# In[34]:


#set the price of coffee


# In[ ]:


if order == "frappuccino":
 price = 13
elif order == "black coffee":
 price = 8
elif order == "espresso":
 price = 10
elif order == "latte":
 price = 6
elif order == "cappucino":
 price = 9
else:
 print("sorry, we don`t have that here.")


# In[ ]:


#ask the customer how many coffees they would like 
#and store it in the variable quantity


# In[ ]:


quantity = input("how many coffees would you like?\n")


# In[ ]:


total = price * int(quantity)


# In[ ]:


print(total)


# In[ ]:


print("thank you. your total is: $" + str(total) )


# In[ ]:


print("sonuds good " + name + ", we`ll have your " + quantity +  " " + order + " ready for you in a moment \n ")


# In[ ]:





# In[ ]:





# In[ ]:




