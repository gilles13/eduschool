\name{eduschool_path}
\alias{eduschool_path}
\title{Localiser une ressource eduschool}
\usage{eduschool_path(..., must_work = TRUE)}
\arguments{
\item{...}{Composantes du chemin sous \code{inst/}.}
\item{must_work}{Produire une erreur si la ressource n'existe pas.}
}
\description{Localise une ressource aussi bien dans un package installé que dans un arbre source en développement.}
\value{Un chemin de fichier.}
