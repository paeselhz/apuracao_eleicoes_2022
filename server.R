library(shiny)
shinyServer(function(input, output, session) {
  
  server_files <-
    list.files(
      path = "tabs",
      pattern = "*_server",
      recursive = TRUE,
      full.names = TRUE
    )
  
  purrr::walk(server_files, ~source(.x, local = TRUE))
  
})