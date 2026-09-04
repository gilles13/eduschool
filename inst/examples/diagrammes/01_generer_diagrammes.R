# Exemples de génération des diagrammes eduschool

# Catalogue des diagrammes disponibles
diagrammes_disponibles()

# Sortie HTML autonome
diagramme_parcours_scolaire(ouvrir = FALSE)
diagramme_package("architecture_si", ouvrir = FALSE)
diagramme_package("tests_package", ouvrir = FALSE)

# Sortie SVG autonome
produire_diagramme_svg("parcours_scolaire")
produire_diagramme_svg("architecture_si")

# Depuis l'arbre source : régénérer les SVG utilisés par les vignettes
# generer_diagrammes_documentation()

# Régénérer à la fois les SVG documentaires et toutes les pages HTML
# generer_documentation_visuelle()
