library(tidyverse)

source("scripts/setup.R")

#Linearity
rats %>% ggplot(aes(x = age, y = weight))+
  geom_line(aes(group = rat), color="gray", linewidth=0.5)+
  geom_smooth(aes(x = age, y = weight), formula = y~x, se = F, method="lm")+
  labs(
    x = "Age",
    y = "Weight"
  )+
  theme

#Normality of weights
ggplot(rats, aes(x = weight, fill = factor(age))) +
  geom_density(alpha = 0.6) +
  labs(
    title = "Density Plot of Rat Weights by Age",
    x = "Weight",
    y = "Density",
    fill = "Age"
  ) +
  theme

