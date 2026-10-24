# Retrouver les textes officiels associes a une notion documentaire

Les liens notion-theme sont editoriaux. Les extraits et leurs pages sont
transcrits des Bulletins officiels. Un lien ne prouve pas qu'une
rubrique particuliere correspond a une capacite de la notion.

## Usage

``` r
texte_officiel(
  notion_id,
  format = c("html", "data.frame"),
  fichier = NULL,
  ouvrir = interactive()
)
```

## Arguments

- notion_id:

  Identifiant pratique de notions() ; les identifiants MAT\_\* sont
  documentaires et restent acceptes pour les usages existants. Voir
  modalites_bo("notions_documentaires") pour leur liste.

- format:

  Format de sortie : tableau R ou page HTML.

- fichier:

  Chemin HTML facultatif.

- ouvrir:

  Ouvrir la page dans le navigateur.

## Value

Un data.frame ou, pour HTML, le chemin du fichier (invisible).
