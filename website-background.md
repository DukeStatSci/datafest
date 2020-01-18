Simple Website Background for a Regression Analysis Course
================
Dr. Maria Tackett
12.20.2018

``` r
library(tidyverse)
library(readr)
library(cowplot)
```

Introduction
------------

This document contains the code used to make the background image for the [STA 210 Spring 2019](https://www2.stat.duke.edu/courses/Spring19/sta210.001/) course website. This background can be used to start a discussion with students about using data visualization to understand the relationship between multiple variables.

The Data
--------

The [Capital Bikeshare data](https://archive.ics.uci.edu/ml/datasets/bike+sharing+dataset) is used to create this background. Each plot uses a combination of the following variables:

-   `cnt`: number of bike rentals
-   `season`: 1 - Winter, 2 - Spring, 3 - Summer 4 - Fall
-   `atemp`: feeling temperature ÷ 50 (in degrees Celsius) <br>

``` r
bikeshare <- read_csv("https://raw.githubusercontent.com/matackett/data/master/capital-bikeshare.csv")          
```

``` r
bikeshare <- bikeshare %>%
  mutate(season = case_when(
    season==1 ~ "Winter",
    season==2 ~ "Spring",
    season==3 ~ "Summer",
    season==4 ~ "Fall"
  )) %>% 
  select(season,atemp,cnt)
```

``` r
# k means clustering for plot p1

bike.cl <- kmeans(bikeshare[,2:3], 4, nstart = 20)
bikeshare <- 
  bikeshare %>% 
  mutate(cluster=as.factor(bike.cl$cluster))
```

The Plots
---------

A few notes about the plots:

-   The plots used in this background are scatterplot, density plot, contour plot, linear smoothing, side-by-side boxplots, and area plots. See the [ggplot2 cheat sheet](https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf) for details and more plot options.

-   The titles, axes, and legend have been removed for each plot. These elements can be easily added by removing the `theme()` modifiers.

``` r
alpha.level = 0.5 

p1 <- ggplot(data=bikeshare,aes(x=atemp,y=cnt,color=cluster)) +
  geom_point(alpha=alpha.level) +
  theme_void() +
  theme(legend.position="none")

p2 <- ggplot(data=bikeshare,aes(x=cnt,fill=season)) +
  geom_density(alpha=alpha.level) +
  theme_void() +
  theme(legend.position="none")

p3 <- ggplot(data=bikeshare,aes(x=cnt,y=atemp,color=season)) +
  geom_density2d() +
  theme_void() +
  theme(legend.position="none")

p4 <- ggplot(data=bikeshare,aes(x=atemp,y=cnt,color=season)) +
  geom_smooth(se=FALSE) +
  theme_void() +
  theme(legend.position="none")

p5 <- ggplot(data=bikeshare,aes(x=season,y=cnt,fill=season)) +
  geom_boxplot(alpha=alpha.level) +
  theme_void() +
  theme(legend.position="none")

p6 <- bikeshare %>%
  ggplot(aes(x=atemp,y=cnt)) + 
  geom_point(aes(color=season)) + 
  geom_smooth(color="#606060",se=FALSE) +
  theme_void() +
  theme(legend.position="none")

plot_grid(p1,p2,p3,p4,p5,p6,ncol=3)
```

![](website-background_files/figure-markdown_github/make-plots-1.png)

``` r
# modify file location
ggsave("static/img/bikeshare-reg-plots.png",scale=2)
```
