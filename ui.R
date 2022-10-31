shinyUI(
  fluidPage(
    ##-- Favicon ----
    tags$head(
      tags$link(rel = "shortcut icon", href = "img/logo.ico"),
      #-- biblio js ----
      tags$link(rel="stylesheet", type = "text/css",
                href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"),
      tags$link(rel="stylesheet", type = "text/css",
                href = "https://fonts.googleapis.com/css?family=Open+Sans|Source+Sans+Pro")
    ),
    ##-- Logo ----
    list(tags$head(HTML('<link rel="icon", href="img/icon.png",
                        type="image/png" />'))),
    div(style="padding: 1px 0px; width: '100%'",
        titlePanel(
          title="", windowTitle = "Apuração Eleições 2022"
        )
    ),
    theme = "styles.css",
    # theme = shinythemes::shinytheme("lumen"),
    navbarPage(
      title = "",
      id = "navbar",
      theme = "styles.css",
      selected = "home",
      fluid = TRUE,
      home_ui,
      presidenciais_ui,
      estaduais_ui
      # sobre
    )
  )
)