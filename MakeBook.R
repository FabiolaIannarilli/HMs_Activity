#' This will generate the book
bookdown::render_book("index.Rmd", bookdown::gitbook(split_by="section", split_bib=FALSE, new_session = TRUE))
bookdown::render_book("index.Rmd", "bookdown::gitbook")
bookdown::render_book("index.Rmd", "bookdown::gitbook", new_session=TRUE)
bookdown::render_book("index.Rmd", bookdown::gitbook(split_bib=FALSE, new_session = TRUE))

#' Then to create the 3-d plots, need to rerun:
chapter <- ".Rmd"
bookdown::preview_chapter(chapter) 


#' To open the html (gitbook) version of the book.
browseURL("_book/index.html")
