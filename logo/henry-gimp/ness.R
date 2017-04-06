
library(rgdal)
library(magrittr)

shape <- readOGR(dsn = "newengland", layer = "NEWENGLAND_POLY")

png("newengland.png", width = 600, height = 600)
par(mar = rep(.1, 4))
plot(shape, lwd = 10)
dev.off()

