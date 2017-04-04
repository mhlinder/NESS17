
outdir <- "tex/out"
outprogram <- file.path(outdir, "detailed-program.tex")

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
    out <- out[-c(1,3)]
    out
}
parse_orgchair <- function(s) {
    out <-
        s %>%
        str_match_all("\\*(.*):\\* \\*\\*(.*)\\*\\*(, (.*))*") %>%
        unlist
    if (length(out) == 4) {
        out <- out[-1]

    } else if (length(out) == 5) {
        out <- out[2:3]
    } else {
        out <- out[-c(1, 5)]
    }
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

    session$orgchair <- parse_orgchair(s[regex_match[,"orgchair"]])

    speakers_ix <- which(regex_match[,"speakers"])
    n_speakers <- length(speakers_ix)
    speakers <- list()
    for (j in 1:n_speakers) {
        ix <- speakers_ix[j]
        speaker <- list()
        speaker$raw <- s[ix]

        tmp <- parse_raw_speaker(s[ix])
        speaker$name <- tmp[1]
        if (length(tmp) > 1) {
            speaker$affiliation <- gsub("&", "\\\\&", tmp[2])
        }

        if (regex_match[ix+1,"paper"]) {
            speaker$paper <-
                s[ix+1] %>%
                gsub("^ +", "", .) %>%
                gsub("\"", "", .)
        }
        speakers[[j]] <- speaker
    }
    session$speakers <- speakers

    session$location <- gsub("\\*", "", s[regex_match[,"location"]])

    sessions[[i]] <- session
}

n_sessions <- length(sessions)

## Match abstract to session

session_titles <- sapply(sessions, . %>% use_series("title"))
df_submitted_papers <- df[matches$Paper,]

m <- matrix(NA, nrow(df_submitted_papers), n_sessions)

for (i in 1:nrow(df_submitted_papers)) {
    p <- df_submitted_papers[i,]
    s <- p$session
    for (j in 1:n_sessions) {
        m[i, j] <- stringdist(s, session_titles[j])
    }
}

## Maps the corresponding entry in `df_submitted_papers` to the index
## for its session in `sessions`
ix_closest <- apply(m, 1, which.min)

## Output latex

ix_morning <- schedule[[1]]$ix
ix_afternoon <- schedule[[2]]$ix
morning <- list(df = sessions[ix_morning:(ix_afternoon-1)],
                label = "Morning sessions")
afternoon <- list(df = sessions[ix_afternoon:n_sessions],
                  label = "Afternoon sessions")

lines <- ""
for (timeslot in list(morning, afternoon)) {
    df <- timeslot$df
    lines <- c(lines, sprintf("\\subsection*{%s}", timeslot$label), "")
    for (session in df) {
        lines <- c(lines, sprintf("\\subsubsection*{%s}", session$title))
        lines <- c(lines, "")

        o <- session$orgchair
        if (length(o) == 3) {
            lines <- c(lines, sprintf("\\emph{%s:} \\textbf{%s}, %s",
                                      o[1], o[2], o[3]))
        } else if (length(o) == 6) {
            lines <- c(lines, sprintf("\\emph{%s:} \\textbf{%s}, %s \\\\",
                                      o[1], o[2], o[3]))
            lines <- c(lines, sprintf("\\emph{%s:} \\textbf{%s}, %s",
                          o[4], o[5], o[6]))
        } else {
            lines <- c(lines, sprintf("\\emph{%s:} \\textbf{%s}", o[1], o[2]))
        }
        lines <- c(lines, "")

        lines <- c(lines, "\\begin{enumerate}")
        for (speaker in session$speakers) {

            if (is.null(speaker$paper)) {
                lineend <- ""
            } else {
                lineend <- "\\\\"
            }

            if (speaker$affiliation != "") {
                lines <- c(lines, sprintf("\\item \\textbf{%s}, %s %s",
                                          speaker$name, speaker$affiliation, lineend))
            } else {
                lines <- c(lines, sprintf("\\item \\textbf{%s} %s", speaker$name, lineend))
            }

            if (!is.null(speaker$paper))
                lines <- c(lines, sprintf("``%s''", speaker$paper))
        }
        lines <- c(lines, "\\end{enumerate}", "")
        lines <- c(lines, sprintf("\\emph{%s} \\\\[.5em]", session$location), "")
    }
}

f <- file(outprogram)
writeLines(lines, f)
close(f)

