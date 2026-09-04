\name{ouvrir_base}
\alias{ouvrir_base}
\alias{eduschool_init}
\title{Ouvrir une base DuckDB}
\usage{
ouvrir_base(fichier = ":memory:", importer = TRUE)
eduschool_init(fichier_base = ":memory:", importer = TRUE)
}
\arguments{
\item{fichier}{Chemin du fichier DuckDB ou \code{":memory:"}.}
\item{fichier_base}{Chemin du fichier DuckDB ou \code{":memory:"}.}
\item{importer}{Importer les CSV distribués dans DuckDB.}
}
\description{Ouvre une connexion DuckDB et, si demandé, y importe les référentiels du package.}
\value{\code{ouvrir_base()} retourne une connexion DBI ; \code{eduschool_init()} retourne un contexte contenant cette connexion.}
