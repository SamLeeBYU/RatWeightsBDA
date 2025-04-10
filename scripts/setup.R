library(tidyverse)
library(patchwork)
library(sysfonts)

font_add("cm", regular="fonts/cmunrm.ttf")
showtext::showtext_auto()

theme <- theme_minimal(base_size = 24, base_family = "cm") +
  theme(
    #axis.text.x = element_text(angle = 75, hjust = 1),
    axis.title.x = element_text(face = "bold"),
    axis.title.y = element_text(face = "bold"),
    axis.text = element_text(face = "bold"),
    panel.background = element_rect(fill = "#F7F7F7"),
    panel.grid.major = element_line(color = "#E3E3E3"),
    panel.grid.minor = element_line(color = "#F0F0F0"),
    plot.title = element_text(hjust = 0.5, face = "bold")
  )

blue <- "#66a3ff"
orange <- "#ffb366"

rats <- readxl::read_xlsx("data/ratdata.xlsx") %>% pivot_longer(
  str_c("rat", 1:30),
  names_to = "rat",
  values_to = "weight"
) %>% group_by(rat) %>% mutate(
  j = 1:5
) %>% ungroup()
