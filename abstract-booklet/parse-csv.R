
library(magrittr)
library(dplyr)

library(readr)
library(stringr)

## Load CSV of abstract submissions

indata <-
    read_csv("abstracts-2017-03-28.csv")

## Filter out abstracts
df <-
    indata %>%
    filter(!is.na(session))
n <- nrow(df)

## Replace some old names
replace <- list("Bayesian Applications in High-dimensional and Multivariate Modeling (Song)"
                = "Song, Bayesian Applications in High-dimensional and Multivariate Modeling")

for (r in names(replace)) {
    df$session[df$session == r] <- replace[[r]]
}

## First regex matches sessions, second matches posters
abstract_regexes <- c("([0-9]{2}\\. )?([a-zA-Z, ]*), ([a-zA-Z, ]*)", # (No.) Last, Title
                      "00\\. Poster session")
matches <- vector("list", length(abstract_regexes))

## Loop over all abstracts
for (i in 1:n) {
    a <- df[i,]

    ## Check which regex---session, poster
    re <- sapply(abstract_regexes, . %>% grepl(., a$session))
    if (!any(re)) stop(sprintf("There was no match for the session \"%s\"", a$session))

    ix <- which(re)
    if (length(ix) > 1) stop(sprintf("Session \"%s\" matched multiple regexes", a$session))

    ## Record regex index
    matches[[ix]] <- c(matches[[ix]], i)
}

## Load invited sessions description
mdfile <- "../md/invited-sessions.md"
raw <- readChar(mdfile, file.info(mdfile)$size)
md <-
    raw %>%
    ## Remove HTML
    gsub("<br />", "", .) %>%
    ## Split according to session
    strsplit("-----") %>%
    unlist %>%
    ## Remove header text
    .[-1]

## Parse session data
N <- length(md)
sessions <- vector("list", N)
session_regexes <- c(title    = "^## ",
                     orgchair = "^\\*[^ ]",
                     speaker  = "^\\* ")

for (i in 1:N) {
    ## Find session titles with linebreaks and reformat them
    s0 <- md[i]
    re <- "\"([^\"]*)\""
    m <- gregexpr(re, s0)
    regmatches(s0, m) <-
        regmatches(s0, m) %>%
        lapply(. %>% gsub("\\n +", " ", .))

    ## Split on newlines
    s <-
        s0 %>%
        strsplit("\\n") %>%
        unlist
    ## Remove empty lines
    s <- s[s != ""]
    ## Check whether session name matches regexes
    regex_match <- sapply(session_regexes, . %>% grepl(s))
    ## If didn't match, record in column `other`
    regex_match <- cbind(regex_match,
                         ## Didn't match any
                         other = apply(regex_match, 1, . %>% any %>% !.))

    ## Get line
    title <-
        regex_match[,"title"] %>%
        which %>%
        s[.] %>%
        gsub(session_regexes["title"], "", .)
    if (length(title) > 1) stop("More than one title!")

    orgchair <- s[regex_match[,"orgchair"]]

    papers_ix <- which(regex_match[,"other"])
    if (length(papers_ix) > 0) {
        n_papers <- length(papers_ix)
        papers <- vector("list", n_papers)
        for (j in 1:n_papers) {
            ix <- papers_ix[j]
            papers[j] <- s[ix]
        }
    }
}

