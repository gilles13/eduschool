\name{outils_eduschool}
\alias{outils_eduschool}
\alias{jairangeoubordel}
\title{Retrouver les outils eduschool dans le code source}
\usage{
outils_eduschool(texte = NULL, internes = FALSE)

jairangeoubordel(texte = NULL, internes = FALSE)
}
\arguments{
\item{texte}{Mot ou fragment a rechercher, par exemple \code{"ensembles"}, \code{"quiz"} ou \code{"revision"}. \code{NULL} retourne tout l'inventaire demande.}
\item{internes}{Inclure les fonctions internes. \code{FALSE} par defaut.}
}
\value{
Un \code{data.frame} avec la fonction, son fichier source, son usage documentaire et son caractere public ou interne.
}
\description{
Sert de boussole dans l'arbre source du package. L'inventaire est derive du code et du \code{NAMESPACE}, sans catalogue manuel a maintenir.
}
