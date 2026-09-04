# Diagramme des parcours scolaires actuellement modélisés
parcours = diagramme_parcours_scolaire(ouvrir = FALSE)

# Architecture du mini système d'information
architecture = diagramme_package("architecture_si", ouvrir = FALSE)

# Chaîne de tests et de contrôle du package
tests = diagramme_package("tests_package", ouvrir = FALSE)

c(parcours, architecture, tests)
