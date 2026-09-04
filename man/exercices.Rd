\name{exercices}
\alias{generer_exercice}
\alias{generer_lot_exercices}
\alias{generer_fiche}
\title{Générer des exercices}
\usage{
generer_exercice(modele_id, niveau_id, capacite_id = NA_character_, difficulte = 1, seed = NULL)
generer_lot_exercices(modele_id, niveau_id, n = 10, capacite_id = NA_character_, difficulte = 1, seed = 1)
generer_fiche(niveau_id, capacite_id = NULL, n = 10, difficulte = 1, seed = 1)
}
\arguments{
\item{modele_id}{Identifiant du modèle d'exercice.}
\item{niveau_id}{Identifiant du niveau scolaire.}
\item{capacite_id}{Identifiant de capacité facultatif.}
\item{difficulte}{Niveau de difficulté.}
\item{seed}{Graine aléatoire pour rendre la génération reproductible.}
\item{n}{Nombre d'exercices.}
}
\description{Génère des exercices mathématiques reproductibles à partir du catalogue du package.}
\value{Un exercice sous forme de liste ou une liste d'exercices.}
