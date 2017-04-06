################################################################################
### a simple script that reproduces NESS logo with R
### version controled by git
################################################################################


### packages needed
pkg <- c("ggplot2", "maps", "png")

## attach the packages and install them if necessary
new.pkg <- pkg[! (pkg %in% installed.packages()[, "Package"])]
if (length(new.pkg))
    install.packages(new.pkg, repos = "https://cloud.r-project.org")
invisible(sapply(pkg, library, character.only = TRUE))


### define the name of output PNG file
out_filled <- "nessLogo_filled.png"
out_polygon <- "nessLogo_polygon.png"


### New England area:
## Connecticut, Rhode island, Massachusetts, Vermont, New hampshire, and Maine
statePloy <- map_data("state")
nessDat <- subset(statePloy,
                  region %in% c("connecticut", "rhode island", "massachusetts",
                                "vermont", "new hampshire", "maine"))

## define sample color (taken from UConn logo)
nessColor <- rgb(0, 14, 47, maxColorValue = 255)

## filled version
p_filled <- ggplot(nessDat) +
    geom_polygon(aes(x = long, y = lat, group = group),
                 color = "white",
                 fill = nessColor, size = 0.5) +
    theme_bw() + labs(x = "", y = "") +
    scale_y_continuous(breaks = NULL) +
    scale_x_continuous(breaks = NULL) +
    theme(panel.border =  element_blank(),
          panel.spacing = unit(0, "pt"))

ggsave(p_filled, filename = out_filled, width = 4, height = 4, dpi = 300)

## polygon version
p_polygon <- ggplot(nessDat) +
    geom_polygon(aes(x = long, y = lat, group = group),
                 color = nessColor,
                 fill = "white", size = 0.8) +
    theme_bw() + labs(x = "", y = "") +
    scale_y_continuous(breaks = NULL) +
    scale_x_continuous(breaks = NULL) +
    theme(panel.border =  element_blank(),
          panel.spacing = unit(0, "pt"))

ggsave(p_polygon, filename = out_polygon, width = 4, height = 4, dpi = 300)


### for transparent background
alpha <- function(pngFile, outFile = pngFile, ...)
{
    img <- png::readPNG(pngFile)
    dimLen <- dim(img)
    rMat <- img[, , 1L]
    gMat <- img[, , 2L]
    bMat <- img[, , 3L]
    ## replace white background
    aVec <- as.integer(rMat < 1 | gMat < 1 | bMat < 1)
    newImg <- array(c(img, aVec), dim = dimLen + c(0, 0, 1))
    writePNG(newImg, outFile)
}

alpha(out_filled)
alpha(out_polygon)
