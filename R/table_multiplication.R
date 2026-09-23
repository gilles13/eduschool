#' Tables de multiplication
#'
#' @param n Tables a produire. Par defaut, de 1 a 9.
#'
#' @export
table_multiplication = function(n = 1:9) {
  data.frame(
    table = rep(n, each = 10),
    multiplicateur = rep(1:10, times = length(n)),
    resultat = rep(n, each = 10) * rep(1:10, times = length(n))
  )
}
