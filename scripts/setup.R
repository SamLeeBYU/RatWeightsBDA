library(tidyverse)
library(patchwork)

theme <- theme_minimal(base_size = 12) +
  theme(
    panel.background = element_rect(fill = "#F7F7F7"),
    panel.grid.major = element_line(color = "#E3E3E3"),
    panel.grid.minor = element_line(color = "#F0F0F0")
  )

rats <- readxl::read_xlsx("data/ratdata.xlsx") %>% pivot_longer(
  str_c("rat", 1:30),
  names_to = "rat",
  values_to = "weight"
) %>% group_by(rat) %>% mutate(
  j = 1:5
) %>% ungroup()
