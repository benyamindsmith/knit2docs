#' Knit .Rmd File to Google Docs
#'
#' Knit a .Rmd file to a Google Doc (stored on Google Drive)
#'
#' @param rmd_file The file path of the .Rmd file that you want to knit.
#' @param doc_name The title of the Doc
#' @param overwrite Overwrite file if it exists. See the `overwrite` argument in googledrive::drive_upload()
#' @param path specify the path where the Google Doc will live. See the `path` argument in googledrive::drive_upload()
#' @import rmarkdown
#' @import googledrive
#' @examples
#' # NOTRUN
#' knit2docs(
#' system.file("rmd/test.Rmd",package="knit2docs"),
#' doc_name=".Rmd to Docs"
#' )

knit2docs<- function(rmd_file,
                     doc_name=".Rmd to Docs",
                     path = NULL,
                     overwrite=TRUE){
  # Temporary File
  temp_file<- tempfile(fileext = ".docx")
  rmarkdown::render(rmd_file, "word_document", output_file = temp_file)
  # Write to docs
  googledrive::drive_upload(temp_file,
                            name = doc_name,
                            type = "application/vnd.google-apps.document",
                            path = path,
                            overwrite = overwrite)
}
