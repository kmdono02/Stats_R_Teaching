library(tidyverse)
library(readr)

# Base r Plotting (very brief)
# Use plot() function

# Option 1: dataset with only 2 variables, can just specify dataset as argument
plot(cars) # cars is example dataset included in R for tutorial purposes

# Option 2: Specify X and Y variables separately for plot
ibis_data <- read_csv("../Data/Cross-sec_full.csv", na = c(".","","NA"))
# Plotting scatterplot of AOSI total score and MSEL cognitive score at 6 months
plot(x=ibis_data$`V06 aosi,total_score_1_18`, 
     y=ibis_data$`V06 mullen,composite_standard_score`)
# Note that this is a base R function, so you have to use standard notation unlike
# the tidyverse functions from before.  That is, we need to specify the variables
# as separate vectors in the data frame using the data$x notation

# you can adjust traits of plot like title, x and y axis labels and limits, etc.
# plot() function is sometimes useful (see later sessions), but ggplot is much 
# better option in general as you will see

# ggplot2 Plotting
# ggplot2 is a package for R which is included in the tidyverse package
# loading tidyverse loads all of its packages (dplyr, ggplot2, etc.)

# ggplot works by considering your plot as a set of layers plot on top of one another
# plus a setting used to tweak aspects of these layers

# consider the same plot as the above example.
# First, we initialize a ggplot using the ggplot() option
# Here you can specify global settings for the plot, that is, things you want to
# carry through for all of the plot layers

ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                   y=`V06 mullen,composite_standard_score`))
# We specify the dataset for the whole plot, as well as the x and y axis variables
# for the whole plot (mapping argument).  Note that for settings in the plot that
# equal variables in the data, you must wrap them around the aes() function so that
# R knows these objects comes from the data referenced before and don't stand alone.
# Note also that as one before, since the variable names include spaces and commas,
# we must wrap their names around single quotes `` so ggplot knows they are a single
# variable name

# now we have our canvas to paint our plot onto.  Let's add a layer of points to
# create a scatterplot.  This is done using the geom_point() function.  We add the
# layer using the + key

ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                   y=`V06 mullen,composite_standard_score`))+
  geom_point()

# within the geom_point() function call, we can tweak settings for the points/layer
# such as their size, shape, and color using different arguments

ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                   y=`V06 mullen,composite_standard_score`))+
  geom_point(size=5, color="blue", shape=2)

# See https://www.datanovia.com/en/blog/ggplot-point-shapes-best-tips/
# for the different shape types available

# We can also have this settings depend on variables in the data.  This is done
# using the mapping with aes() call we used before, though this changes the settings
# for this layer only.  Thus the settings specified inside the ggplot() call create 
# default settings for the whole plot which can be altered for specific layers later on
# We color the points based on diagnosis

ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                   y=`V06 mullen,composite_standard_score`))+
  geom_point(mapping=aes(color=SSM_ASD_v24))

# Let's add another layer, by adding a trend line to illustrate the association
# between the variables

ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                   y=`V06 mullen,composite_standard_score`))+
  geom_point(mapping=aes(color=SSM_ASD_v24))+
  geom_smooth()

# The shaded region represent error for the trend line estimate
# This is nice, but it would useful to separate trend lines per group
ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                   y=`V06 mullen,composite_standard_score`))+
  geom_point(mapping=aes(color=SSM_ASD_v24))+
  geom_smooth(mapping=aes(color=SSM_ASD_v24))

# To do so and then also color by group, we need to specify this within the layer
# Note that we have specified the same setting, color=group, for both layers
# Thus, we may want to just add this to the default settings in the ggplot so we
# are not writing this line over and over
ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                   y=`V06 mullen,composite_standard_score`,
                                   color=SSM_ASD_v24))+
  geom_point()+
  geom_smooth()

# Much cleaner.
# Suppose we want to add the overall trend line for the whole sample back in
# We can do this by adding in a second geom_smooth layer to paint on top of the 
# current plot

ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                   y=`V06 mullen,composite_standard_score`,
                                   color=SSM_ASD_v24))+
  geom_point()+
  geom_smooth()+
  geom_smooth(color="blue")

# We have to "turn off" the color=group setting in the ggplot() call in this layer.
# We can do this by specifying a static color like "blue" for the layer.
# If you don't like the error bars, add se=FALSE for the layers of interest

ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                   y=`V06 mullen,composite_standard_score`,
                                   color=SSM_ASD_v24))+
  geom_point()+
  geom_smooth(se=FALSE)+
  geom_smooth(color="blue")

# An additional layer we can add to the plot are facets.  These are just panels
# which divide your plots up based on a variable of interest.
# There are two ways you can facet.  One is using the facet_grip() function.
# This lets you directly specify the row and column variable using what is called
# formula notation: y ~ x
# You will see this again during the regression section.
# Let's only facet by gender

ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                   y=`V06 mullen,composite_standard_score`,
                                   color=SSM_ASD_v24))+
  geom_point()+
  geom_smooth(se=FALSE)+
  geom_smooth(color="blue")+
  facet_grid(Gender~.)

# Or columns
ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                   y=`V06 mullen,composite_standard_score`,
                                   color=SSM_ASD_v24))+
  geom_point()+
  geom_smooth(se=FALSE)+
  geom_smooth(color="blue")+
  facet_grid(~Gender)

# Or row and column variable
ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                   y=`V06 mullen,composite_standard_score`,
                                   color=SSM_ASD_v24))+
  geom_point()+
  geom_smooth(se=FALSE)+
  geom_smooth(color="blue")+
  facet_grid(Study_Site~Gender)

# There is also facet_wrap(), which I'll leave to use to explore.
# It uses the same y ~ x notation; see what you can create!

# To finalize this plot (we'll remove the Site faceting), we can edit the various
# text in the plot: title, subtitle, axis labels, tick marks, limits, etc.

# Various functions are used depending on what you want to edit
# labs() lets you edit the title, subtitle, footer (caption), legend titles
# among others

ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                   y=`V06 mullen,composite_standard_score`,
                                   color=SSM_ASD_v24))+
  geom_point()+
  geom_smooth(se=FALSE)+
  geom_smooth(color="blue")+
  facet_grid(~Gender)+
  labs(title="My title", subtitle = "My subtitle", caption="My footer",
       color=" 24 month ASD diagnosis")

# xlab() and ylab() let you edit the x and y axis 
ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                   y=`V06 mullen,composite_standard_score`,
                                   color=SSM_ASD_v24))+
  geom_point()+
  geom_smooth(se=FALSE)+
  geom_smooth(color="blue")+
  facet_grid(~Gender)+
  labs(title="My title", subtitle = "My subtitle", caption="My footer",
       color=" 24 month ASD diagnosis")+
  xlab("6 month AOSI Total Score")+
  ylab("6 month MSEL Composite Std. Score")

# For any text you can specify \n to force a new line
ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                   y=`V06 mullen,composite_standard_score`,
                                   color=SSM_ASD_v24))+
  geom_point()+
  geom_smooth(se=FALSE)+
  geom_smooth(color="blue")+
  facet_grid(~Gender)+
  labs(title="My title", subtitle = "My subtitle", caption="My footer",
       color=" 24 month ASD diagnosis")+
  xlab("6 month AOSI\nTotal Score")+
  ylab("6 month MSEL\nComposite Std. Score")

# To edit axis limits there are various functions you can use, including
# xlim(), ylim(), scale_x_continuous(), scale_y_continuous(),
# scale_x_discrete(), scale_y_discrete()
# The last 2 functions give you a lot of options for editing the limits, tick 
# marks, etc.
# The discrete functions are used if your variable is discrete (a character or factor)

# The last set of functions we discuss are the theme() related functions
# These let you fine tune the asthetics of the plot, specifically 
# font size and styles, sizes of various elements, etc.
# We'll go over how to increase the size of all of your plot text which is 
# important if you want to export your plot to an image

ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                   y=`V06 mullen,composite_standard_score`,
                                   color=SSM_ASD_v24))+
  geom_point()+
  geom_smooth(se=FALSE)+
  geom_smooth(color="blue")+
  facet_grid(~Gender)+
  labs(title="My title", subtitle = "My subtitle", caption="My footer",
       color=" 24 month ASD diagnosis")+
  xlab("6 month AOSI\nTotal Score")+
  ylab("6 month MSEL\nComposite Std. Score")+
  theme(text = element_text(size=20))

# text refers to all text in the gplot, with element_text() being a function used
# to specify the traits you wish to change (size, font style, font type such as
# bold or italicize, color, etc.).  
# You can also specify certain text you wish to edit instead of all text by using 
# that text's name.  For example below, we rotate the x axis labels.  This is
# useful when you have long labels that overlap one another (if the axis variable
# is a group label for example)

ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                   y=`V06 mullen,composite_standard_score`,
                                   color=SSM_ASD_v24))+
  geom_point()+
  geom_smooth(se=FALSE)+
  geom_smooth(color="blue")+
  facet_grid(~Gender)+
  labs(title="My title", subtitle = "My subtitle", caption="My footer",
       color=" 24 month ASD diagnosis")+
  xlab("6 month AOSI\nTotal Score")+
  ylab("6 month MSEL\nComposite Std. Score")+
  theme(axis.text.x = element_text(angle=90, hjust=1))

# angle specified the amount of rotation and hjust adds some horizontal justification
# to the text
# We can also combine these two changes

ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                   y=`V06 mullen,composite_standard_score`,
                                   color=SSM_ASD_v24))+
  geom_point()+
  geom_smooth(se=FALSE)+
  geom_smooth(color="blue")+
  facet_grid(~Gender)+
  labs(title="My title", subtitle = "My subtitle", caption="My footer",
       color=" 24 month ASD diagnosis")+
  xlab("6 month AOSI\nTotal Score")+
  ylab("6 month MSEL\nComposite Std. Score")+
  theme(text = element_text(size=20),
        axis.text.x = element_text(angle=90, hjust=1))

# Lastly, there are some theme templates that you can specify that greatly alter
# the look of your plot.  I often use the theme_bw() template, though see
# https://ggplot2.tidyverse.org/reference/ggtheme.html for more examples

ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                   y=`V06 mullen,composite_standard_score`,
                                   color=SSM_ASD_v24))+
  geom_point()+
  geom_smooth(se=FALSE)+
  geom_smooth(color="blue")+
  facet_grid(~Gender)+
  labs(title="My title", subtitle = "My subtitle", caption="My footer",
       color="24 month ASD diagnosis")+
  xlab("6 month AOSI\nTotal Score")+
  ylab("6 month MSEL\nComposite Std. Score")+
  theme_bw()+
  theme(text = element_text(size=20))

# Note that you should specify the template call first, then add the theme()
# call to include your additional edits

# To close out this script, let's consider a different plot
# Let's do a boxplot of MSEL by diagnosis
# Instead of the geom_point() layer, we will call the geom_boxplot() layer

ggplot(data=ibis_data, mapping=aes(x=SSM_ASD_v24,
                                   y=`V06 mullen,composite_standard_score`,
                                   color=SSM_ASD_v24))+
  geom_boxplot()+
  facet_grid(~Gender)+
  labs(title="My title", subtitle = "My subtitle", caption="My footer",
       color="24 month ASD diagnosis")+
  xlab("24 month ASD diagnosis")+
  ylab("6 month MSEL\nComposite Std. Score")+
  theme_bw()+
  theme(text = element_text(size=20),
        axis.text.x = element_text(angle=90, hjust=1))

# We see that color just colors the outlime of the boxplot, we need to use fill
# instead to fill in the plots with color

ggplot(data=ibis_data, mapping=aes(x=SSM_ASD_v24,
                                   y=`V06 mullen,composite_standard_score`,
                                   fill=SSM_ASD_v24))+
  geom_boxplot()+
  facet_grid(~Gender)+
  labs(title="My title", subtitle = "My subtitle", caption="My footer",
       fill="24 month ASD diagnosis")+
  xlab("24 month ASD diagnosis")+
  ylab("6 month MSEL\nComposite Std. Score")+
  theme_bw()+
  theme(text = element_text(size=20))

# We can make this plot cleaner by formatting the ASD group labels
# We could do this in the data itself, though we may just want to edit the way 
# the labels are displayed in the plot whether then changing the whole dataset
# This can be done using the scale_x_discrete() function

ggplot(data=ibis_data, mapping=aes(x=SSM_ASD_v24,
                                   y=`V06 mullen,composite_standard_score`,
                                   fill=SSM_ASD_v24))+
  geom_boxplot()+
  facet_grid(~Gender)+
  labs(title="My title", subtitle = "My subtitle", caption="My footer",
       fill="24 month ASD diagnosis")+
  scale_x_discrete(labels=c("NO_ASD" = "ASD Negative", 
                            "YES_ASD" = "ASD Positive"))+
  xlab("24 month ASD diagnosis")+
  ylab("6 month MSEL\nComposite Std. Score")+
  theme_bw()+
  theme(text = element_text(size=20))

# You can see we adjust the group labels using the label= argument, with a
# vector inside of the form "old"="new", with groups separated by commas

# Note that this DOES NOT change the color labels as these are not part of the x
# axis.  You can do this using the scale_fill_discrete() function

ggplot(data=ibis_data, mapping=aes(x=SSM_ASD_v24,
                                   y=`V06 mullen,composite_standard_score`,
                                   fill=SSM_ASD_v24))+
  geom_boxplot()+
  facet_grid(~Gender)+
  labs(title="My title", subtitle = "My subtitle", caption="My footer",
       fill="24 month ASD diagnosis")+
  scale_x_discrete(labels=c("NO_ASD" = "ASD Negative", 
                            "YES_ASD" = "ASD Positive"))+
  scale_fill_discrete(labels=c("NO_ASD" = "ASD Negative", 
                            "YES_ASD" = "ASD Positive"))+
  xlab("24 month ASD diagnosis")+
  ylab("6 month MSEL\nComposite Std. Score")+
  theme_bw()+
  theme(text = element_text(size=20))

# ggplot gives you a lot of flexibility for choosing the colors you would like used
# to represent the groups.
# The function used depends on if you are using a color call, fill call, etc.
# For fill calls, you can edit the colors using scale_fill_manual()

ggplot(data=ibis_data, mapping=aes(x=SSM_ASD_v24,
                                   y=`V06 mullen,composite_standard_score`,
                                   fill=SSM_ASD_v24))+
  geom_boxplot()+
  facet_grid(~Gender)+
  labs(title="My title", subtitle = "My subtitle", caption="My footer",
       fill="24 month ASD diagnosis")+
  scale_x_discrete(labels=c("NO_ASD" = "ASD Negative", 
                            "YES_ASD" = "ASD Positive"))+
  scale_fill_discrete(labels=c("NO_ASD" = "ASD Negative", 
                               "YES_ASD" = "ASD Positive"))+
  scale_fill_manual(values=c("green", "red"))+
  xlab("24 month ASD diagnosis")+
  ylab("6 month MSEL\nComposite Std. Score")+
  theme_bw()+
  theme(text = element_text(size=20))

# You see that this overwrites the previous scale_fill_discrete() call and removes 
# our labels!  
# Luckily, we can also use the scale_fill_manual() call to change labels AND 
# specify colors for the fill

ggplot(data=ibis_data, mapping=aes(x=SSM_ASD_v24,
                                   y=`V06 mullen,composite_standard_score`,
                                   fill=SSM_ASD_v24))+
  geom_boxplot()+
  facet_grid(~Gender)+
  labs(title="My title", subtitle = "My subtitle", caption="My footer",
       fill="24 month ASD diagnosis")+
  scale_x_discrete(labels=c("NO_ASD" = "ASD Negative", 
                            "YES_ASD" = "ASD Positive"))+
  scale_fill_manual(labels=c("NO_ASD" = "ASD Negative", 
                             "YES_ASD" = "ASD Positive"),
                    values=c("green", "red"))+
  xlab("24 month ASD diagnosis")+
  ylab("6 month MSEL\nComposite Std. Score")+
  theme_bw()+
  theme(text = element_text(size=20))

# So why would you ever use scale_fill_discrete() then?  It uses the default colors
# which are usually quite nice.  scale_fill_manual() requires you to specify your
# own colors, so if you just want to change the labels or other traits, but want 
# to stick with the default colors, you can just use scale_fill_discrete()

# For continuous variables which are colored, you can use various functions
# to specify gradients for the color range.
# See http://www.sthda.com/english/wiki/ggplot2-colors-how-to-change-colors-automatically-and-manually
# For examples and details

# Finally, let's save our plot as an image on our computer
# First, note that all we have done so far is print the plots.
# We can also save the plot as an object an R using the same commands we have seen
# before

ex_plot <- ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                              y=`V06 mullen,composite_standard_score`,
                                              color=SSM_ASD_v24))+
  geom_point()+
  geom_smooth(se=FALSE)+
  geom_smooth(color="blue")+
  facet_grid(~Gender)+
  labs(title="My title", subtitle = "My subtitle", caption="My footer",
       color="24 month ASD diagnosis")+
  xlab("6 month AOSI\nTotal Score")+
  ylab("6 month MSEL\nComposite Std. Score")+
  theme_bw()+
  theme(text = element_text(size=20))

# and then can print it by calling the object
ex_plot

# to save a plot as an image, the best way for a ggplot is using the function
# ggsave()
# The first two arguments are the plot of interest, and then the file path and 
# name you'd like to save the plot to 

ggsave(ex_plot, filename = "plots/scatterplot_ex.jpg")

# We can also save as a png by changing the extension in the filename
ggsave(ex_plot, filename = "plots/scatterplot_ex.png")

# To edit the size of the saved plot, we have some options.  I like to use the
# scale= argument to expand or shrink the plot

ggsave(ex_plot, filename = "plots/scatterplot_ex.png",
       limitsize = FALSE, scale=2.5)

# Note that R will annoyingly limit the size of the plot you can save by default,
# requiring to add in the limitsize = FALSE argument call for "big" plots.  I
# just add this argument in for all saved plots as it doesn't do any harm (unless
# your plot is huge and takes forever to save which will likely never happen)

# Note that you can omit the first argument if you print the plot before hand, as
# the function automatically takes the last printed plot as the first agrument 
# something else is specified there

ex_plot
ggsave(filename = "plots/scatterplot_ex.png",
       limitsize = FALSE, scale=2.5)

# Or alternatively
ggplot(data=ibis_data, mapping=aes(x=`V06 aosi,total_score_1_18`,
                                   y=`V06 mullen,composite_standard_score`,
                                   color=SSM_ASD_v24))+
  geom_point()+
  geom_smooth(se=FALSE)+
  geom_smooth(color="blue")+
  facet_grid(~Gender)+
  labs(title="My title", subtitle = "My subtitle", caption="My footer",
       color="24 month ASD diagnosis")+
  xlab("6 month AOSI\nTotal Score")+
  ylab("6 month MSEL\nComposite Std. Score")+
  theme_bw()+
  theme(text = element_text(size=20))

ggsave(filename = "plots/scatterplot_ex.png",
       limitsize = FALSE, scale=2.5)

# You now should have all the tools to understand the gist of the NBA data plots
# code included in the RMD file which corresponds to the HTML slides.
# Have fun playing around with your data visualization!  We will cover much more
# visualization examples with ggplot once we start discussing specific analyses
# in later sessions!  Next session we discuss R Markdown (that RMD file is an
# example of this)!
