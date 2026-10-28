# Produire une transcription du BO en HTML ou PDF

Utilise le Markdown associe a un programme et un modele BO dedie. Le PDF
officiel reste la source de reference.

## Usage

``` r
produire_bo(
  programme,
  format = c("html", "pdf"),
  dossier = NULL,
  ouvrir = interactive()
)
```

## Arguments

- programme:

  Identifiant du programme (programme_id), a retrouver avec
  modalites_bo("programmes").

- format:

  Format de sortie : html ou pdf.

- dossier:

  Repertoire de sortie ; temporaire si NULL.

- ouvrir:

  Ouvrir le document genere.

## Value

Chemin du document genere (invisible).
