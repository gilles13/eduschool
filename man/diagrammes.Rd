\name{diagrammes}
\alias{diagrammes_disponibles}
\alias{produire_diagramme_html}
\alias{diagramme_parcours_scolaire}
\alias{diagramme_package}
\title{Diagrammes HTML eduschool}
\description{
Fonctions légères pour produire des pages HTML contenant des diagrammes Mermaid
sur les parcours scolaires et le fonctionnement interne du package.
}
\usage{
diagrammes_disponibles()

produire_diagramme_html(
  type = "parcours_scolaire",
  fichier = NULL,
  ouvrir = FALSE
)

diagramme_parcours_scolaire(fichier = NULL, ouvrir = FALSE)

diagramme_package(
  type = c("architecture_si", "tests_package"),
  fichier = NULL,
  ouvrir = FALSE
)
}
\arguments{
  \item{type}{Identifiant du diagramme à produire.}
  \item{fichier}{Chemin du fichier HTML. Si \code{NULL}, une sortie est créée sous \code{rapports/sorties/diagrammes/}.}
  \item{ouvrir}{Ouvrir le fichier dans le navigateur après sa création.}
}
\value{
\code{diagrammes_disponibles()} retourne un data.frame. Les fonctions de génération
retournent invisiblement le chemin absolu du fichier HTML produit.
}
\details{
Le rendu Mermaid est chargé depuis jsDelivr lors de l'ouverture de la page HTML.
Une connexion réseau est donc nécessaire pour le rendu graphique. Le code Mermaid
reste visible dans le fichier HTML même si le script distant n'est pas disponible.
}
