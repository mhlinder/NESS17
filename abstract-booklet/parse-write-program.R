
write_detailed_program <- FALSE
write_abstracts <- FALSE
write_posters <- FALSE
write_participants <- TRUE

outdir <- "tex/out"
outprogram <- file.path(outdir, "detailed-program.tex")
outabstracts <- file.path(outdir, "abstracts.tex")
outposters <- file.path(outdir, "posters.tex")
outparticipants <- file.path(outdir, "participants.tex")

library(magrittr)
library(dplyr)

library(readr)
library(stringr)

library(stringdist)
library(tools)

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
        tolower %>%
        toTitleCase %>%
        gsub(session_regexes["title"], "", .) %>%
        gsub("\v", " ", .)
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
        speaker$name <- tmp[1] %>% tolower %>% toTitleCase
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
    session$df_papers_ix <- c()

    sessions[[i]] <- session
}

n_sessions <- length(sessions)

## Match abstract to session

session_titles <- sapply(sessions, . %>% use_series("title"))
df_papers <- df[matches$Paper,]

abstract_files <- list.files("bak/save", "*.txt", full.names = TRUE)

m <- matrix(NA, nrow(df_papers), n_sessions)

df_papers$path <- NA
for (i in 1:nrow(df_papers)) {
    p <- df_papers[i,]
    s <- p$session
    for (j in 1:n_sessions) {
        m[i, j] <- stringdist(s, session_titles[j])
    }
    df_papers$path[i] <- abstract_files[which(grepl(p$conf, abstract_files))]
}

## Maps the corresponding entry in `df_papers` to the index
## for its session in `sessions`
df_papers$match <- apply(m, 1, which.min)
n_papers <- nrow(df_papers)

for (i in 1:n_papers) {
    p <- df_papers[i,]

    sessions[[p$match]]$df_papers_ix <-
        c(sessions[[p$match]]$df_papers_ix,
          i)
}

## Output latex

## Detailed program booklet with a listing of each
ix_morning <- schedule[[1]]$ix
ix_afternoon <- schedule[[2]]$ix
morning <- list(l = sessions[ix_morning:(ix_afternoon-1)],
                label = "Morning sessions")
afternoon <- list(l = sessions[ix_afternoon:n_sessions],
                  label = "Afternoon sessions")

lines_program <- ""
for (timeslot in list(morning, afternoon)) {
    l <- timeslot$l
    lines_program <- c(lines_program, sprintf("\\subsection*{%s}", timeslot$label), "")
    for (session in l) {
        lines_program <- c(lines_program, sprintf("\\subsubsection*{%s}", session$title))
        lines_program <- c(lines_program, "")

        o <- session$orgchair
        if (length(o) == 5) {
            lines_program <- c(lines_program, sprintf("\\emph{%s:} \\textbf{%s}, %s",
                                      o[2], o[3], o[5]))
        } else if (length(o) == 10) {
            lines_program <- c(lines_program, sprintf("\\emph{%s:} \\textbf{%s}, %s \\\\",
                                      o[2], o[3], o[5]))
            lines_program <- c(lines_program, sprintf("\\emph{%s:} \\textbf{%s}%s",
                                      o[7], o[8], o[9]))
        } else {
            lines_program <- c(lines_program, sprintf("\\emph{%s:} \\textbf{%s}", o[1], o[2]))
        }
        lines_program <- c(lines_program, "")

        lines_program <- c(lines_program, "\\begin{enumerate}")
        for (speaker in session$speakers) {

            if (is.null(speaker$paper)) {
                lineend <- ""
            } else {
                lineend <- "\\\\"
            }

            if (speaker$affiliation != "" && !is.na(speaker$affiliation)) {
                lines_program <- c(lines_program, sprintf("\\item \\textbf{%s}, %s %s",
                                          speaker$name, speaker$affiliation, lineend))
            } else {
                lines_program <- c(lines_program, sprintf("\\item \\textbf{%s} %s", speaker$name, lineend))
            }

            if (!is.null(speaker$paper))
                lines_program <- c(lines_program, sprintf("``%s''", speaker$paper))
        }
        lines_program <- c(lines_program, "\\end{enumerate}", "")
        lines_program <- c(lines_program, sprintf("\\emph{%s} \\\\[.5em]", session$location), "")
    }
}

if (write_detailed_program) {
    f <- file(outprogram)
    writeLines(lines_program, f)
    close(f)
}

## Write abstracts
lines_abstract <- ""
for (timeslot in list(morning, afternoon)) {
    l <- timeslot$l
    lines_abstract <- c(lines_abstract, sprintf("\\subsection*{%s}", timeslot$label), "")
    for (session in l) {
        n_papers <- length(session$df_papers_ix)
        if (n_papers > 0) {
            lines_abstract <- c(lines_abstract, sprintf("\\subsubsection*{%s}", session$title), "")
            lines_abstract <- c(lines_abstract, "\\begin{itemize}")
            for (i in 1:n_papers) {
                ix <- session$df_papers_ix[i]
                p <- df_papers[ix,]

                lines_abstract <- c(lines_abstract, sprintf("\\item \\textbf{%s}, %s \\\\", p$presenter, p$affiliation))
                lines_abstract <- c(lines_abstract, sprintf("``%s'' \\\\", p$title))
                lines_abstract <- c(lines_abstract, p$authors, "", "")

                intxt <-
                    readLines(p$path) %>%
                    gsub("\v", " ", .)
                lines_abstract <- c(lines_abstract, intxt, "")
            }
            lines_abstract <- c(lines_abstract, "\\end{itemize}", "")
        }
    }
}

if (write_abstracts) {
    f <- file(outabstracts)
    writeLines(lines_abstract, f)
    close(f)
}

## Posters
df_posters <- df[matches$Poster,]
n_posters <- nrow(df_posters)

lines_poster <- "\\subsection*{Posters}"
lines_poster <- c(lines_poster, "\\begin{itemize}")
for (i in 1:n_posters) {
    p <- df_posters[i,]

    lines_poster <- c(lines_poster, sprintf("\\item \\textbf{%s}, %s \\\\", p$presenter, p$affiliation))
    lines_poster <- c(lines_poster, sprintf("``%s'' \\\\", p$title))
    lines_poster <- c(lines_poster, p$authors, "", "")

    intxt <-
        readLines(sprintf("bak/save/%s.txt", p$conf)) %>%
        gsub("\v", " ", .)
    lines_poster <- c(lines_poster, intxt, "")
}
lines_poster <- c(lines_poster, "\\end{itemize}", "")

if (write_posters) {
    f <- file(outposters)
    writeLines(lines_poster, f)
    close(f)
}

save(sessions, morning, afternoon, schedule, file = "parsed.Rdata")

## List of participants

reg <- read_csv("bak/reg.csv")
participants <-
    reg$name %>%
    tolower %>%
    toTitleCase

participants <-
    participants %>%
    gsub("^.* ", "", .) %>%
    order %>%
    participants[.]

if (write_participants) {
    f <-  file(outparticipants)
    writeLines(participants, f, sep = "\\\\\n")
    close(f)
}

