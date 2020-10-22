# Comment

## Single values
# Printing values
print(x=1)
print(1)
1
"hello world"
a # results in error, values equal to words (denoted as characters) within "" or ''

# Saving values as objects using <-
x <- 1
x = 1
print(x=x)
print(x)
x # reference to saved object x.  When by itself prints object

x <- "hello world"
x

## Vectors: representing multiple values
# Notice we don't have to also call print; i.e. print(c(1,2,3,4)). See above
c(1,2,3,4)
c("a","b","c","d")

x <- c(1,2,3,4)
y <- c("a","b","c","d")

# All values must of same "type"
c(1,2,"c","d")

## List: storing multiple values, types
list(c(1,2,3,4), c(5,6,7,8))
list(c("a","b","c","d"), c("e", "f"))
list(c(1,2,3,4),c("a","b","c","d"))
# Can see, one element of list can be numbers, other characters, etc.
list(list(c(1,2,3,4), c("a","b")), list(c(5,6,7,8), c("c","d")))
# Or Lists of Lists!  Lists are versatile, elements can be of any type

## Matrix: storing two-dimensional representations
matrix(c(1,2,3,4), nrow=2, ncol=2)
matrix(c("a","b","c","d"), nrow=2, ncol=2)
matrix(c("a","b",3,4), nrow=2, ncol=2) 
# like vectors, all values of same type
matrix(c("a","b","3","4"), nrow=2, ncol=2) 
# but numbers can be denoted as characters using quotes

# Arithmetic 
sum(1,1)
1+1 # alias is +, alias means alternative name or "shortcut"
x <- 1
y <- 1
x+y
1+"1" 
# error. Cannot add number and character (even if character is actually a "number")

sum(1,-1)
1-1

prod(1,2,3)
1*2*3

prod(2,1/2)
2/2

## Functions
# All above: c(), print(), list(), matrix(), sum(), prod() ex. of functions
# General form of function f(x=...,y=...,...)
# f is name of function, x is argument name, ... after = is argument value
# arguments separated by ,
# actions on objects done in R by functions
# argument names DON"T need quotes around them, i.e. don't need "x"=...

x <- prod(2,1/2) # result of function call prod(2,1/2) saved as object x

## Object types
# Recall we have seen values as numbers (denoted numeric) and characters
TRUE # special type: called logical
FALSE # other logical value. Used to test conditions (discussed later)
NA # denotes "missing value"
"hello world! :0" # characters can have spaces, non-letter symbols, numbers, ...
x y <- "won't work" # R object names CANNOT have spaces
x_y <- "will work"
1_y <- "won't work" # R object names CANNOT start with numbers
y_1 <- "will work"
# Can use functions to see type of value/object
class(1) # numeric
class("1") # character
class(TRUE) # logical

## Data frames
# Recall matrices, all values must of same type
# How then do we store datasets with variables of different types?
# Data frames to the rescue!
x <- data.frame(c(1,2,3,4), c("a","b","c","d")) # each argument is a new column
x # have 2 columns, one of numbers and one of characters
class(x) # can see of special class called data.frame
typeof(x) # but is actually just a special type of list
# data frames = type of list will be useful later!

## Loading real data
# Ok cool, but what about real data and not toy examples
read.csv(file="../Data/AOSI_small.csv", na.strings = ".")
# Store as object to realize reference and edit later
data <- read.csv(file="../Data/AOSI_small.csv", na.strings = ".")
data
# What magic is this?
# 1) read.csv(file=..., na.strings=...) is function which reads CSVs as data.frames in R
# file=... is argument where you specify the file path of the CSV as a string
# "../" refers to relative path name with respect to working directory
# can refer to file paths without having to type full path out!
# na.strings=... tells R which values (as a char vector) to denote as missing or NA
# for example=c(".","") would tell R values marked as "." or "", empty cell, = NA
# what happens if you omit na.strings="." in this example?

## Working directory (WD)
# Wait what is this?
getwd() # prints out current working directory. Set to directory where script is
setwd("blah") # sets working directory to directory named blah.
# Specify directory of interest as a folder path inside "" as argument
# WD is the default folder R looks to save and load things.  
# Also used as starting place to navigate relative path names, see above example

## Subsetting objects
# Vectors

# Lists

# Matrices

# Data frames

# To come: advanced subsetting through tidyverse ...