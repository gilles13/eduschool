if (!requireNamespace("devtools", quietly = TRUE)) stop("Installer devtools pour ce script.")
devtools::document()
devtools::test()
devtools::check()
