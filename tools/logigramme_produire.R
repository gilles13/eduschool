logigramme_produire = function(noeuds = "workflow-produire-noeuds.csv", liens = "workflow-produire-liens.csv") {
  n = read.csv(noeuds, sep = ";", stringsAsFactors = FALSE, check.names = FALSE)
  l = read.csv(liens, sep = ";", stringsAsFactors = FALSE, check.names = FALSE)
  echapper = function(x) gsub('"', '\\"', x, fixed = TRUE)
  labels = paste0(echapper(n$titre), "\\n", echapper(n$description))
  lignes_noeuds = paste0('"', n$id, '" [label="', labels, '"];')
  lignes_liens = paste0('"', l$de, '" -> "', l$vers, '"', ifelse(nzchar(l$libelle), paste0(' [label="', echapper(l$libelle), '"]'), ''), ';')
  dot = paste("digraph workflow {", "graph [rankdir=TB, nodesep=0.25, ranksep=0.45];", "node [shape=box, style=rounded, fontname=Helvetica, fontsize=10];", "edge [fontname=Helvetica, fontsize=9];", paste(lignes_noeuds, collapse="\n"), paste(lignes_liens, collapse="\n"), "}", sep="\n")
  DiagrammeR::grViz(dot)
}
