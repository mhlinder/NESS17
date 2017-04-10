
library(magrittr)
library(dplyr)

library(readr)

abs <-
    read_csv("bak/abstracts.csv")
reg <-
    read_csv("bak/reg.csv")

regnums <- abs$reg %>% gsub("[\t ]", "", .)

ix_missing <- which((regnums == "NESS17-1234") | (!regnums %in% reg$invoice))

abs[ix_missing,]$presenter

