### File paths
## Working directory (WD)
# Wait what is this?
getwd() # prints out current working directory. Set to directory where script is
setwd("blah") # sets working directory to directory named blah.
# Specify directory of interest as a folder path inside "" as argument
# WD is the default folder R looks to save and load things.  
# Also used as starting place to navigate relative path names, see above example

## Absolute path names
# Suppose I want to change my WD to specific folder.
# One way: provide whole folder location to R
setwd("C:\Users\kdono\OneDrive - University of North Carolina at Chapel Hill\Documents\School\Research\Truong Research\Stats_R_Teaching\11_12_2020")
# Create error.  Why?
# Annoyingly, Windows and R using different definitions for separators in a file path name.
# R and Apple use / BUT Windows uses \ which means something different in R.  Thus we need ...
setwd("C:/Users/kdono/OneDrive - University of North Carolina at Chapel Hill/Documents/School/Research/Truong Research/Stats_R_Teaching/11_12_2020")
# Works!
getwd()
# Print out current WD to verify all is good
# NOTE:
# when opening up R Studio by double clicking on a script, the WD is set to the script location automatically

# Ok, how about opening a file in R (CSV for example)
# We again need to tell R where the file is located
data <- read.csv(file = "C:/Users/kdono/OneDrive - University of North Carolina at Chapel Hill/Documents/School/Research/Truong Research/Stats_R_Teaching/Data/AOSI_small.csv", na.strings = ".")

## Relative path names
# But this is very cumbersome.  Let's use our WD combined with relative path names to make this easier
data <- read.csv(file="../Data/AOSI_small.csv", na.strings = ".")

# Much cleaner.  R automatically fills in the WD address "C:/Users/kdono"...
# Use of ../ means "go back" one folder in the WD

### Subsetting objects
## Vectors
# Recall example
x <- c(1,2,3,4)
# Square brackets used to specify location in x
x[1]

# Prints 1st entry only
x[c(1,3)]
# Use vector c(1,3) to specify only 1st and 3rd entries
y <- x[c(1,3)]
# Can also save new subsetted vector
x <- x[c(1,3)]
# Or rewrite 

## Matrices
# Matrices have 2 dimensions (rows AND columns)
# Recall 
x <- matrix(c(1,2,3,4), nrow=2, ncol=2)
# Again use square brackets, but now have two slots: 1) rows 2) columns
x[1,]
# Print 1st row, blank second slot -> all columns
x[,1]
# Print 1st column, blank first slot -> all rows
x[1,1]
# Print 1st row, 1st column
x[1,c(1,2)]
# Print 1st row, 1st and 2nd column

## Lists
# Lists can have many (2+) dimensions
# Recall
x <- list(c(1,2,3,4), c(5,6,7,8))

# To specify outer layer of list, use [[ ]] instead of []
x[[1]]
# Prints first outer layer of list, vector c(1,2,3,4)
x[[2]]

# Now, within a given outer layer, can subset further based on layer type
x[[1]][c(1,2)]
# 1st outer layer is a vector, so can now use vector rules for subsetting
x[c(1,2)]
# To specify multiple outer layers, need to use [] instead

# What if we give the outer layers names?
x <- list("obj_1"=c(1,2,3,4), "obj_2"=c(5,6,7,8))
x[["obj_1"]]
# Can use names to subset as well (note use of "".  R doesn't know what obj_1 is since it does not stand alone)
x$obj_1
# Can also use $ instead, note "" not needed.  $ is a specically formatted shortcut so it doesn't follow the "" rule

## Data frames
# Data frames are just lists, so we can use the examples above 
data <- read.csv(file="../Data/AOSI_small.csv", na.strings = c(".","","NA"))
data[[1]]
# Each column of a data frame is an element of the list.  We select the 1st column
data$Identifiers
# Can also use it's name

# One benefit of data frames is that they appear like matrices.  We also use the matrix subsetting rules with data frames
data[1,]
# Pulls out all data frame 1st subject
data[,1]
# 1st vairable/column in data
data[c(1,2,3),]
# 1st three subjects' data

# To come: advanced subsetting through tidyverse ...