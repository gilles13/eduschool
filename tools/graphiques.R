# tests graphiques

setwd("~/repogit/eduschool/")

source("inst/graphiques/_etiquettes.R")
source("inst/graphiques/triangle_rectangle.R")

p = graphique_triangle_rectangle(
  angle = "A",
  longueurs = c(AB = 6, AC = 8),
  unite = "cm",
  parallele = list(
    position = .5,
    points = c("D", "E"),
    cotes = c(AD = "3 cm", DB = "3 cm", AE = "4 cm", EC = "4 cm", DE = "5 cm")
  )
)
print(p)

print(graphique_triangle_rectangle(angle = "A", longueurs = c(AB = 6, AC = 8), unite = "cm"))

print(graphique_triangle_rectangle(
  angle = "A",
  longueurs = c(AB = 6, AC = 8),
  parallele = list(position = .4, cotes = c(AD = "x", DB = "?", AE = "3,2 cm"))
))

source("inst/graphiques/_etiquettes.R")
source("inst/graphiques/triangle_rectangle.R")
p = graphique_triangle_rectangle(
  angle = "A",
  longueurs = c(AB = 6, AC = 8),
  unite = "cm",
  parallele = list(
    position = .5,
    points = c("D", "E"),
    cotes = c(AD = "3 cm", DB = "3 cm", AE = "4 cm", EC = "4 cm", DE = "5 cm")
  )
)
print(p)

graphique_triangle_rectangle(
  angle = "A",
  longueurs = c(AB = 6, AC = 8, BC = 10),
  unite = "cm",
  parallele = list(
    position = .5,
    cotes = c(AD = "3 cm", AE = "4 cm", DE = "5 cm")
  )
)
