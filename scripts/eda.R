library(tidyverse)
library(lme4)

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

model <- lmer(weight ~ 1 + age + (1 + age | rat), data=rats)

resids <- residuals(model)

ggplot(data.frame(residuals = resids), aes(sample = residuals)) +
  stat_qq() +
  stat_qq_line() +
  labs(
    title = "Q-Q Plot of Residuals",
    x = "Theoretical Quantiles",
    y = "Sample Quantiles"
  ) +
  theme
