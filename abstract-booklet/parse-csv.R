
library(magrittr)
library(dplyr)

library(readr)
library(stringr)

library(stringdist)

## Load CSV of abstract submissions

indata <-
    read_csv("bak/abstracts.csv")

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
names(matches) <- c("Paper", "Poster")

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
session_regexes <- c(schedule = "^# ",
                     title    = "^## ",
                     orgchair = "^\\*[^* ]",
                     speakers = "^\\* ",
                     paper    = "^ *\"",
                     location = "^\\*\\*")

parse_raw_speaker <- function(s) {
    out <-
        s %>%
        str_match_all("^\\* \\*\\*(.*)\\*\\*(, (.*))*$") %>%
        unlist
    out
}

schedule <- list() ## Locations and contents of h1 headers that signal
                   ## the two scheduled times
x <- 1
for (i in 1:N) {
    session <- list()

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

    ## Record location of assignment to time slot
    if (any(regex_match[,"schedule"])) {
        schedule[[x]] <- list(ix = i, matches = s[regex_match[,"schedule"]])
        x <- x+1
    }

    ## Get line
    session$title <-
        regex_match[,"title"] %>%
        which %>%
        s[.] %>%
        gsub(session_regexes["title"], "", .)
    if (length(title) > 1) stop("More than one title!")

    session$orgchair <- s[regex_match[,"orgchair"]]

    speakers_ix <- which(regex_match[,"speakers"])
    n_speakers <- length(speakers_ix)
    speakers <- list()
    for (j in 1:n_speakers) {
        ix <- speakers_ix[j]
        speaker <- list()
        speaker$raw <- s[ix]

        tmp <- parse_raw_speaker(s[ix])
        tmp <- tmp[-c(1,3)]
        speaker$name <- tmp[1]
        if (length(tmp) > 1) speaker$affiliation <- tmp[2]

        if (regex_match[ix+1,"paper"]) {
            speaker$paper <-
                s[ix+1] %>%
                gsub("^ +", "", .) %>%
                gsub("\"", "", .)
        }
        speakers[[j]] <- speaker
    }
    session$speakers <- speakers

    sessions[[i]] <- session
}


## Match abstract to session

session_titles <- sapply(sessions, . %>% use_series("title"))
df_submitted_papers <- df[matches$Paper,]

m <- matrix(NA, nrow(df_submitted_papers), length(session_titles))

for (i in 1:nrow(df_submitted_papers)) {
    p <- df_submitted_papers[i,]
    s <- p$session
    for (j in 1:length(session_titles)) {
        m[i, j] <- stringdist(s, session_titles[j])
    }
}

ix_closest <- apply(m, 1, which.min)
for (i in 1:nrow(df_submitted_papers)) {
    p <- df_submitted_papers[i,]
    cat(sprintf("%90s\n%90s\n\n", p$session, session_titles[ix_closest[i]]))
}

