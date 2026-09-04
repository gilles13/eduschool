\name{programmes}
\alias{programmes}
\alias{capacites}
\title{Consulter les programmes et capacités}
\usage{
programmes(discipline_id = NULL, niveau_id = NULL)
capacites(niveau_id = NULL, discipline_id = "MAT", version_id = NULL)
}
\arguments{
\item{discipline_id}{Identifiant de discipline, par exemple \code{"MAT"}.}
\item{niveau_id}{Identifiant de niveau, par exemple \code{"6E"}.}
\item{version_id}{Version d'application facultative, par exemple \code{"2026_2027"}.}
}
\description{Filtre les programmes et les éléments de type capacité à partir des référentiels installés.}
\value{Un \code{data.frame}.}
\examples{
programmes("MAT")
capacites("6E")
}
