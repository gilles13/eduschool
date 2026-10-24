# Presentation facultative des etapes du raisonnement dans le corrige PDF.
.raisonnement_edu = function(x) {
  if (is.null(x) || !nzchar(x)) return("")
  etapes = "(Je vois|Or|Donc)\\s*:"
  trimws(gsub(etapes, "\n\n**\\1 :** ", x, perl = TRUE))
}
