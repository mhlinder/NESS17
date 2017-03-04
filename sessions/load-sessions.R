
library(magrittr)
library(dplyr)

library(readr)

infile <- "20170225.csv"

u <- function(s) unname(s)

indata <-
    read_csv(infile, col_names = FALSE) %>%
    ## "Time"
    select(-X6)

header <- indata[2,] %>% unlist
header["X2"] <- "Organizer Name"
header <- unname(header)

n_spkr <-
    header %>%
    grepl("Spkr[0-9] Name", .) %>%
    header[.] %>%
    length

body <- indata[-(1:2),]
colnames(body) <- header

## Sessions that have an organizer
ix <- which(!is.na(body$`Organizer Name`))
sessions <- list()

for (i in ix) {
    s <- body[i,] %>% unlist
    session <- list(ID    = u(s["Session ID"]),
                    Title = u(s["Session title"]))

    session$Organizer <-
        list(Name  = u(s["Organizer Name"]),
             Affil = u(s["Organizer Institute"]),
             Email = u(s["Organizer Email"]))

    if (is.na(s["Chair Name"])) {
        session$Organizer$Chair <- TRUE
        session$Chair <- NULL
    } else {
        session$Organizer$Chair <- FALSE
        session$Chair <-
            list(Name  = u(s["Chair Name"]),
                 Affil = u(s["Chair Institute"]),
                 Email = u(s["Chair Email"]))
    }

    sessions$Speakers <- list()
    for (k in 1:n_spkr) {
        s_str <- sprintf("Spkr%d", k)
        speaker <-
            list(Name  = u(s[sprintf("%s Name", s_str)]),
                 Affil = u(s[sprintf("%s Institute", s_str)]),
                 Email = u(s[sprintf("%s Email", s_str)]),
                 Title = u(s[sprintf("%s Title", s_str)]))
        session$Speakers[[k]] <- speaker
    }

    sessions[[session$ID]] <- session
}

