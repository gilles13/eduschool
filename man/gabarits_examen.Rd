\name{gabarits_examen}
\alias{gabarits_examen}
\title{Gabarits d'exercices d'examen}
\usage{
gabarits_examen(examen_code = NULL, partie_type = NULL, domaine = NULL, statut = "ACTIF")
}
\arguments{
\item{examen_code}{Code d'examen facultatif.}
\item{partie_type}{Type de partie facultatif.}
\item{domaine}{Domaine mathematique facultatif.}
\item{statut}{Statut des gabarits. Par defaut, seuls les gabarits actifs sont retournes.}
}
\value{Un data.frame.}
\description{Consulte la banque relationnelle de gabarits d'exercices d'examen.}
