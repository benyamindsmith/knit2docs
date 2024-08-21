#' Knit .rmd or .qmd Files to Google Docs
#'
#' Knit a .rmd or .qmd file to a Google Doc (stored on Google Drive)
#'
#' @param rmd_file The file path of the .rmd file that you want to knit.
#' @param qmd_file The file path of the .qmd file that you want to knit.
#' @param doc_name The title of the Doc
#' @param overwrite Overwrite file if it exists. See the `overwrite` argument in googledrive::drive_upload()
#' @param path specify the path where the Google Doc will live. See the `path` argument in googledrive::drive_upload()
#' @import rmarkdown
#' @import quarto
#' @import googledrive
#' @export
#' @examples
#' \dontrun{
#' library(knit2docs)
#' knit2docs(
#' rmd_file=system.file("rmd/test.Rmd",package="knit2docs"),
#' doc_name=".Rmd to Docs"
#' )
#'
#' knit2docs(
#' qmd_file=system.file("qmd/test.qmd",package="knit2docs"),
#' doc_name=".qmd to Docs"
#' )
#' }

knit2docs<- function(rmd_file=NULL,
                     qmd_file = NULL,
                     doc_name=".rmd/.qmd to Docs",
                     path = NULL,
                     overwrite=TRUE){
  # Temporary File
  temp_file<- tempfile(fileext = ".docx")|>basename()

  if(is.null(rmd_file) && is.null(qmd_file)){
    stop("rmd_file and qmd_file is unspecified. Please specify rmd_file or qmd_file arguments.")
  }

  if(!is.null(rmd_file) & !is.null(qmd_file)){
    stop("knit2docs only renders one file type at a time. Please specify one of the rmd_file or qmd_file arguments.")
  }

  if(!is.null(rmd_file)){
    if(grepl("\\.rmd|\\.Rmd|\\.RMD",rmd_file)){
      rmarkdown::render(rmd_file, "word_document", output_file = temp_file)
    }else{
    stop("Invalid file format for rmd_file.")
    }
  }else if (!is.null(qmd_file)){
    if(grepl("\\.qmd|\\.Qmd|\\.QMD",qmd_file)){
      quarto::quarto_render(qmd_file,output_format = "docx", output_file=temp_file)
    }else{
    stop("Invalid file format for qmd_file.")
    }
  }
  # Write to docs
  googledrive::drive_upload(temp_file,
                            name = doc_name,
                            type = "application/vnd.google-apps.document",
                            path = path,
                            overwrite = overwrite)
}
