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

p = graphique_triangle_rectangle(
  angle = "A",
  longueurs = c(AB = 6, AC = 8),
  unite = "cm",
  parallele = list(
    position = .6,
    points = c("D", "E"),
    cotes = c(AD = "3,6 cm")
  )
)
print(p)

p = graphique_triangle_rectangle(
  angle = "C",
  longueurs = c(AC = 15, BC = 4),
  unite = "cm",
  parallele = list(
    position = .82,
    points = c("D", "E"),
    cotes = c(
      CD = "12,3 cm",
      DA = "2,7 cm",
      CE = "3,28 cm",
      EB = "0,72 cm",
      DE = "x"
    )
  )
)
print(p)

source("inst/graphiques/_etiquettes.R")
source("inst/graphiques/triangle_rectangle.R")
p = graphique_triangle_rectangle(
  angle = "C",
  longueurs = c(AC = 15, BC = 4, AB = sqrt(241)),
  unite = "cm",
  parallele = list(
    position = .82,
    points = c("D", "E"),
    cotes = c(
      CD = "12,3 cm",
      DA = "2,7 cm",
      CE = "3,28 cm",
      EB = "0,72 cm",
      DE = "x"
    )
  )
)
print(p)
