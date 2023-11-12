#!/usr/bin/env python
# coding: utf-8

# In[12]:


name = input("What is your name? ")
age = int(input("What is your age? "))

#I used a loop to repeatedly ask for the preferred unit until a valid one is entered
while True:
    preferred_unit = input("What is your preferred unit? metric/us: ")
    preferred_unit_lower = preferred_unit.lower()

    if preferred_unit_lower == "metric":
        weight_kg = int(input("What is your weight in kg? "))
        height_cm = int(input("What is your height in cm? "))
        your_bmi = weight_kg / (height_cm / 100) ** 2
        print(f"Hello, {name}! Your BMI is: {your_bmi:.2f}")

        # BMI Classification
        if your_bmi > 0:
            if your_bmi < 18.5:
                print(f"{name}, you are underweight.")
            elif your_bmi <= 24.9:
                print(f"{name}, you are normal weight.")
            elif your_bmi < 29.9:
                print(f"{name}, you are overweight. You need to exercise more and stop sitting and writing so many Python tutorials.")
            elif your_bmi < 34.9:
                print(f"{name}, you are obese.")
            elif your_bmi < 39.9:
                print(f"{name}, you are severely obese.")
            else:
                print(f"{name}, you are morbidly obese.")
        else:
            print("Enter valid input")

        break  # Exit the loop after processing metric units

    elif preferred_unit_lower == "us":
        weight_lb = int(input("Enter your weight in pounds: "))
        height_in = int(input("Enter your height in inches: "))
        BMI = (weight_lb * 703) / (height_in ** 2)
        print(f"Hello, {name}! Your BMI is: {BMI:.2f}")

        # BMI Classification
        if BMI > 0:
            if BMI < 18.5:
                print(f"{name}, you are underweight.")
            elif BMI <= 24.9:
                print(f"{name}, you are normal weight.")
            elif BMI < 29.9:
                print(f"{name}, you are overweight. You need to exercise more and stop sitting and writing so many Python tutorials.")
            elif BMI < 34.9:
                print(f"{name}, you are obese.")
            elif BMI < 39.9:
                print(f"{name}, you are severely obese.")
            else:
                print(f"{name}, you are morbidly obese.")
        else:
            print("Enter valid input")

        break  # Exit the loop after processing US units

    else:
        print(f"Invalid unit '{preferred_unit}'. Please choose 'metric' or 'us'.")


# In[ ]:




