\name{diagrammes}
\alias{diagrammes_disponibles}
\alias{produire_diagramme_html}
\alias{produire_diagramme_svg}
\alias{diagramme_parcours_scolaire}
\alias{diagramme_package}
\alias{generer_diagrammes_documentation}
\alias{generer_documentation_visuelle}
\title{Diagrammes HTML et SVG de eduschool}
\description{
Fonctions de génération de diagrammes autonomes à partir d'un modèle de graphe
interne à eduschool. Les SVG sont produits directement en R, sans Mermaid,
Node, npm ou autre moteur externe.
}
\usage{
diagrammes_disponibles()

produire_diagramme_html(
  type = "parcours_scolaire",
  fichier = NULL,
  ouvrir = FALSE
)

produire_diagramme_svg(type = "parcours_scolaire", fichier = NULL)

diagramme_parcours_scolaire(fichier = NULL, ouvrir = FALSE)

diagramme_package(
  type = c("architecture_si", "tests_package"),
  fichier = NULL,
  ouvrir = FALSE
)

generer_diagrammes_documentation(repertoire = NULL)

generer_documentation_visuelle(
  repertoire_svg = NULL,
  repertoire_html = NULL
)
}
\arguments{
\item{type}{Identifiant du diagramme. Voir \code{diagrammes_disponibles()}.}
\item{fichier}{Chemin du fichier HTML ou SVG à produire.}
\item{ouvrir}{Ouvrir la page HTML dans le navigateur après sa création.}
\item{repertoire}{Répertoire de destination des SVG documentaires. Par défaut,
\code{man/figures} dans l'arbre source du package.}
\item{repertoire_svg}{Répertoire des SVG documentaires.}
\item{repertoire_html}{Répertoire des pages HTML.}
}
\value{
\code{diagrammes_disponibles()} retourne un \code{data.frame}. Les fonctions
de production retournent invisiblement le chemin du fichier créé.
\code{generer_documentation_visuelle()} retourne invisiblement une liste de
chemins SVG et HTML.
}
\details{
Les sorties HTML embarquent directement le SVG généré par eduschool. Elles ne
chargent aucun script distant. Les SVG de \code{man/figures} peuvent être
versionnés et réutilisés par pkgdown et les vignettes.
}
\examples{
diagrammes_disponibles()

f = tempfile(fileext = ".svg")
produire_diagramme_svg("architecture_si", fichier = f)
}
