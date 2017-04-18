
library(magrittr)
library(dplyr)

library(readr)

indata <-
    read_csv("bak/abstracts.csv")

df <- indata %>% filter(grepl("Poster", session))

write_csv(df, path = "posters.csv")

