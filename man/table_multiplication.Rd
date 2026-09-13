\name{table_multiplication}
\alias{table_multiplication}
\title{Generer une table de multiplication}
\usage{
table_multiplication(max = 9)
}
\arguments{
\item{max}{Plus grand entier de la table. Par defaut 9.}
}
\value{
Une matrice d'entiers dont les lignes et les colonnes portent les facteurs.
}
\description{
Construit une grille de produits entiers de 1 a \code{max}.
}
\examples{
table_multiplication()
table_multiplication(5)
}
