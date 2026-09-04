\name{documentation-pedagogique}
\alias{notions}
\alias{notions_capacite}
\alias{prerequis_notion}
\alias{prerequis_capacite}
\alias{obtenir_rappel}
\alias{rappels_capacite}
\alias{chercher_notions}
\alias{couverture_documentation}
\title{Consulter la documentation pédagogique}
\usage{
notions(discipline_id = NULL)
notions_capacite(capacite_id)
prerequis_notion(notion_id, recursif = FALSE)
prerequis_capacite(capacite_id, recursif = FALSE)
obtenir_rappel(notion_id, collapse = "\\n")
rappels_capacite(capacite_id)
chercher_notions(texte, discipline_id = "MAT")
couverture_documentation(niveau = NULL)
}
\arguments{
\item{discipline_id}{Identifiant de discipline.}
\item{capacite_id}{Identifiant de capacité.}
\item{notion_id}{Identifiant de notion.}
\item{recursif}{Inclure les prérequis transitifs.}
\item{collapse}{Séparateur utilisé pour réunir les lignes Markdown.}
\item{texte}{Texte ou fragments à rechercher.}
\item{niveau}{Niveau scolaire facultatif.}
}
\description{Accès aux notions, aux liens notion-capacité, aux prérequis et aux rappels Markdown.}
\value{Selon la fonction, un \code{data.frame}, une liste ou une chaîne de caractères.}
