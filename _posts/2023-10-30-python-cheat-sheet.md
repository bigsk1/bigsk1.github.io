---
title: Python Cheat Sheet
date: 2023-10-30 12:00:00  -500
categories: [python]
tags: [python] 
image:
  path: /assets/images/headers/python.webp
---

PYTHON 3.6+  CHEAT SHEET

Sample code for quick reference

## String Operations

```python
# String concatenation
full_name = "John" + " " + "Doe"

# String formatting
formatted = f"Hello, {full_name}"

# String methods
lowercase = full_name.lower()
uppercase = full_name.upper()
split_name = full_name.split(" ")

# String slicing
substring = full_name[1:4]
```

## List [ ]

    Mutability: Mutable - CAN CHANGE
    Description: Ordered sequence of elements.
    Common Uses: Storing collections of items, iteration, sorting, etc.
    Notes: Supports indexing and slicing. Elements can be added, modified, or removed.


```python
# Example
my_list = [1, 2, 3]
my_list.append(4)  # Adds 4 to the end of the list

# Creating lists
my_list = [1, 2, 3]

# Appending to list
my_list.append(4)

# Extending list
my_list.extend([5, 6, 7])

# Slicing list
first_two = my_list[:2]

# Removing items
my_list.remove(1)
```

## Tuple ( )

    Mutability: Immutable - CAN NOT CHANGE
    Description: Ordered sequence of elements.
    Common Uses: Storing collections of items that should not be modified.
    Notes: Similar to lists but cannot be altered once defined. Useful for hashable keys in dictionaries.

```python
# Example
my_tuple = (1, 2, 3)
```

## Set { }

    Mutability: Mutable - CAN CHANGE
    Description: Unordered collection of unique elements.
    Common Uses: Removing duplicates, set operations like union and intersection.
    Notes: Items in a set are unique. Adding an existing item has no effect. Sets themselves are mutable, but the elements inside them must be immutable (e.g., numbers, strings, tuples).

```python
# Example
my_set = {1, 2, 3}
my_set.add(4)  # Adds 4 to the set
my_set.add(1)  # No change, since 1 is already in the set
```

## Dictionary {key: value}

    Mutability: Mutable - CAN CHANGE
    Description: Unordered collection of key-value pairs.
    Common Uses: Associative arrays, hash tables.
    Notes: Keys must be immutable (e.g., numbers, strings, tuples), but values can be mutable objects.

```python
# Example
my_dict = {'a': 1, 'b': 2}
my_dict['c'] = 3  # Adds a new key-value pair

# Creating dictionary
my_dict = {'key': 'value'}

# Accessing values
value = my_dict['key']

# Adding new key-value pair
my_dict['new_key'] = 'new_value'

# Removing key-value pair
del my_dict['key']

# Checking if key exists
if 'key' in my_dict:
    print("Key exists")
```
So to break it down for nested dictionary below:

weights: This is a variable that holds a dictionary.
'yelp' and 'turnover': These are keys within the weights dictionary.
config['yelp']['weight'] and config['turnover']['weight']: These are values that are being retrieved from another dictionary (config) and stored as values in the weights dictionary.

```python
# Define a nested dictionary for config

config = {
    'yelp': {
        'weight': 0.6
    },
    'turnover': {
        'weight': 0.4
    }
}

# Define a dictionary for weights that takes values from config
weights = {
    'yelp': config['yelp']['weight'],  # 0.6
    'turnover': config['turnover']['weight']  # 0.4
}
```

## If, Elif, Else
```python
# Basic if-elif-else
x = 10
if x > 5:
    print("x is greater than 5")
elif x == 5:
    print("x is 5")
else:
    print("x is less than 5")

# Check if item is in a list
numbers = [1, 2, 3]
if 2 in numbers:
    print("2 is in the list")

# Check multiple conditions
if x > 5 and x < 15:
    print("x is between 5 and 15")
```


## While Loop
```python
# Basic while loop
count = 0
while count < 5:
    print(count)
    count += 1

# While loop with break
count = 0
while True:
    if count >= 5:
        break
    print(count)
    count += 1
```


## For Loop
```python
# Basic for loop
for i in range(5):
    print(i)

# For loop with list
for num in [0, 1, 2, 3, 4]:
    print(num)
```


## Try and Except
```python
# Basic try-except
try:
    x = 1 / 0
except ZeroDivisionError:
    print("Cannot divide by zero")

# Multiple exceptions
try:
    # code that may raise an exception
    x = 1 / 0
except (ZeroDivisionError, ValueError):
    print("An error occurred")

# Catch exception and get error message
try:
    # code
    x = 1 / 0
except Exception as e:
    print(f"An error occurred: {e}")
```

## Functions
```python
# Basic function
def greet(name):
    return f"Hello, {name}"

# Function with default argument
def greet(name="World"):
    return f"Hello, {name}"

# Function with arbitrary number of arguments
def sum_all(*args):
    return sum(args)

# Function with keyword arguments
def greet_with_log(name, log=False):
    if log:
        print(f"Logging: Greeted {name}")
    return f"Hello, {name}"
```

## File Operations
```python
# Reading a file
with open('file.txt', 'r') as f:
    content = f.read()

# Writing to a file
with open('file.txt', 'w') as f:
    f.write('Hello, World!')

# Appending to a file
with open('file.txt', 'a') as f:
    f.write('\nAppending text')
```

## Importing Modules and Libraries
```python
# Importing entire module
import math

# Importing specific function
from math import sqrt

# Importing and aliasing
import numpy as np
```

## Working with Dates
```python
from datetime import datetime, timedelta

# Get current date and time
now = datetime.now()

# Format date
formatted_date = now.strftime('%Y-%m-%d %H:%M:%S')

# Date arithmetic
tomorrow = now + timedelta(days=1)
```

## Basic Logging to Console
```python
import logging

# Basic logging
logging.basicConfig(level=logging.INFO)
logging.info('This is an info message')
```

## Logging Levels
```python
# Available logging levels in increasing order of severity
logging.debug('Debug message')
logging.info('Informational message')
logging.warning('Warning message')
logging.error('Error message')
logging.critical('Critical error message')
```

## Logging to a File
```python
# Logging to a file
logging.basicConfig(filename='app.log', level=logging.INFO)
logging.info('Logged to file')
```

## Advanced Logging: Handlers and Formatters
```python
import logging

# Create logger
logger = logging.getLogger('my_logger')
logger.setLevel(logging.INFO)

# Create console handler and set level to debug
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.DEBUG)

# Create file handler and set level to info
file_handler = logging.FileHandler('app.log')
file_handler.setLevel(logging.INFO)

# Create formatter
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

# Add formatter to handlers
console_handler.setFormatter(formatter)
file_handler.setFormatter(formatter)

# Add handlers to logger
logger.addHandler(console_handler)
logger.addHandler(file_handler)

# Log messages
logger.debug('Debug message')
logger.info('Info message')
logger.warning('Warning message')
logger.error('Error message')
logger.critical('Critical message')
```

## Exception Logging
```python
try:
    x = 1 / 0
except Exception as e:
    logging.error(f'An error occurred: {e}', exc_info=True)
```

## Conditional Logging
```python
x = 5
if x < 10:
    logging.warning(f'x is less than 10: x={x}')
```

## Arithmetic Operators
```python
print(3 + 2)     # Addition: 5
print(3 - 2)     # Subtraction: 1
print(3 * 2)     # Multiplication: 6
print(3 / 2)     # Division: 1.5
print(3 % 2)     # Modulus: 1
print(3 ** 2)    # Exponentiation: 9
print(3 // 2)    # Floor Division: 1
```

## Comparison Operators
```python
print(3 == 2)    # Equal: False
print(3 != 2)    # Not equal: True
print(3 > 2)     # Greater than: True
print(3 < 2)     # Less than: False
print(3 >= 2)    # Greater than or equal to: True
print(3 <= 2)    # Less than or equal to: False
```

## Logical Operators
```python
print(True and False)    # and: False
print(True or False)     # or: True
print(not True)          # not: False
```

## Assignment Operators
```python
a = 3
a += 2        # Add and assign: a = 5
a -= 1        # Subtract and assign: a = 4
a *= 2        # Multiply and assign: a = 8
a /= 4        # Divide and assign: a = 2.0
```

## Bitwise Operators
```python
print(3 & 2)    # Bitwise AND: 2 (0b11 & 0b10 = 0b10)
print(3 | 2)    # Bitwise OR: 3 (0b11 | 0b10 = 0b11)
print(3 ^ 2)    # Bitwise XOR: 1 (0b11 ^ 0b10 = 0b01)
print(~3)       # Bitwise NOT: -4 (two's complement of 0b11 is -0b100)
print(3 << 1)   # Bitwise left shift: 6 (0b11 << 1 = 0b110)
print(3 >> 1)   # Bitwise right shift: 1 (0b11 >> 1 = 0b1)
```

## Membership Operators
```python
numbers = [1, 2, 3, 4, 5]
print(3 in numbers)       # in: True
print(6 not in numbers)   # not in: True
```

## Identity Operators
```python
a = [1, 2, 3]
b = a
c = [1, 2, 3]
print(a is b)       # is: True (a and b refer to the same list)
print(a is c)       # is: False (a and c are equal but refer to different lists)
print(a is not c)   # is not: True
```
### We can put it all together in a single Python script if needed.

## Example of all code together
Below is an example Python script that integrates various elements: variables, data types, functions, control structures (if, elif, else, while), error handling (try and except), and logging. This example aims to show how these elements can work together in a single Python script.
```python
import logging

# Initialize logging
logging.basicConfig(level=logging.INFO)

# Function Definitions
def greet(name):
    return f"Hello, {name}!"

def is_even(number):
    return number % 2 == 0

def add(a, b):
    return a + b

# Logging example
logging.info("Starting the program")

# Variables
name = "Ivan"
age = 30

# List
numbers = [1, 2, 3, 4]

# Dictionary
person = {'name': 'Ivan', 'age': 30}

# Basic if-elif-else
if age >= 18:
    logging.info("You are an adult.")
elif age >= 13:
    logging.info("You are a teenager.")
else:
    logging.info("You are a child.")

# Using functions
greeting = greet(name)
logging.info(greeting)

# Error handling with try-except
try:
    result = add("10", 20)
except TypeError as e:
    logging.error(f"An error occurred: {e}")

# Loop with while
counter = 0
while counter < 3:
    logging.info(f"Counter is at {counter}")
    counter += 1

# Check if a number is even
if is_even(10):
    logging.info("The number is even.")
else:
    logging.info("The number is odd.")

# Logging example
logging.info("Ending the program")

```
