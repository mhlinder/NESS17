
library(magrittr)
library(dplyr)
library(readr)
library(tools)

print <- function(s) {
    cat(sprintf("%s\n", s))
}

## infile <- "20170205.csv"
infile <- "20170225.csv"

indata <- read_csv(infile, skip = 1)
indata <-
    indata %>%
    select(-X6)

ix <- which(!is.na(indata$Name))

for (i in ix) {
    session <- indata[i,]
    print(sprintf("## %s", toTitleCase(session$`Session title`)))
    print("")
    if (is.na(session$`Chair Name`)) {
        print(sprintf("*Organizer and Chair:* **%s**, %s", session$Name, session$`Organizer Institute`))
    } else {
        print(sprintf("*Organizer:* **%s**, %s<br />", session$Name, session$`Organizer Institute`))
        print(sprintf("*Chair:* **%s**, %s", session$`Chair Name`, session$`Chair Institute`))
    }
    print("")

    if (!is.na(session$`Spkr5 Name`)) {
        n_speaker <- 5
    } else if (!is.na(session$`Spkr4 Name`)) {
        n_speaker <- 4
    } else {
        n_speaker <- 3
    }

    for (j in 1:n_speaker) {
        print(sprintf("* **%s**, %s<br />",
                      session[[sprintf("Spkr%d Name", j)]],
                      session[[sprintf("Spkr%d Institute", j)]]))
        title <- session[[sprintf("Spkr%d Title", j)]]
        if (!is.na(title)) {
            print(sprintf("  \"%s\"", toTitleCase(title)))
        }
    }
    print("")
}

