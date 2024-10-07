#' This will generate the book
bookdown::render_book("index.Rmd", bookdown::gitbook(split_bib=FALSE, new_session = TRUE))

#' To open the html (gitbook) version of the book.
browseURL("_book/index.html")
