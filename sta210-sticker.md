STA 210 Sticker
================
Maria Tackett
12/30/2018

This document contains the code to make the sticker for [STA 210:
Regression
Analysis](https://www2.stat.duke.edu/courses/Spring19/sta210.001/). The
following packages are used in this project:

``` r
library(hexSticker)
library(tidyverse)
library(showtext)
library(nnet)
library(knitr)
```

## The Data

The data is the [Capital Bikeshare data
set](https://archive.ics.uci.edu/ml/datasets/bike+sharing+dataset)
pulled from the UCI Machine Learning Repository. The following variables
are used in this project:

  - `season`: 1 - Winter, 2 - Spring, 3 - Summer 4 - Fall
  - `atemp`: feeling temperature ÷ 50 (in degrees Celsius) <br>

<!-- end list -->

``` r
bikeshare <- read_csv("https://raw.githubusercontent.com/matackett/data/master/capital-bikeshare.csv")    
bikeshare <- bikeshare %>%
  mutate(season = case_when(
    season==1 ~ "Winter",
    season==2 ~ "Spring",
    season==3 ~ "Summer",
    season==4 ~ "Fall"
  )) %>% 
  select(season,atemp)
```

## Fit Model

A multinomial logistic regression model is used to create the main plot.
The response variable is `season` and the predictor variable is `atemp`.

``` r
# fit multinomial logistic model 
# add predicted probabilities to bikeshare data
m <- multinom(season ~  atemp,data=bikeshare)
```

    ## # weights:  12 (6 variable)
    ## initial  value 1013.381178 
    ## iter  10 value 631.237836
    ## iter  20 value 629.144982
    ## final  value 629.144454 
    ## converged

``` r
pred <- as.data.frame(predict.glm(m,type="response"))
bikeshare <- bind_cols(bikeshare,pred)
```

## Make Sticker

``` r
# plot predicted probabilites versus atemp
p <- ggplot(data=bikeshare,aes(x=atemp)) + 
  geom_line(aes(y=Winter),color="#00BFC4") +
  geom_line(aes(y=Spring),color="#F8766D") +
  geom_line(aes(y=Summer),color="#C77CFF") +
  geom_line(aes(y=Fall),color="#7CAE00") +
  theme_minimal() +
  theme(axis.title=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank())
```

``` r
# add font to be used in sticker function
font_add_google("Open Sans", "open")
```

``` r
# create and save sticker
sticker(p, package="STA 210",p_color="#00797C", p_family="open", p_size=7.5, s_x=1, s_y=0.75, s_width=1.2, s_height=1, h_fill = "#FFFFFF", 
        h_color="#00797C", h_size =0.8,
        filename="static/img/sta210_sticker.png")
```

``` r
#display final sticker
include_graphics("static/img/sta210_sticker.png")
```

![](static/img/sta210_sticker.png)<!-- -->
