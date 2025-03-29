library(tidyverse)

rats <- readxl::read_xlsx("data/ratdata.xlsx") %>% pivot_longer(
  str_c("rat", 1:30),
  names_to = "rat",
  values_to = "weight"
)
