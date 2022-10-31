home_ui <-
  tabPanel(
    title = "Home",
    value = "home",
    hr(),
    HTML("<h1><center><strong>Apuração das Eleições Gerais do Brasil - 2022</strong></center></h1>"),
    HTML("<h1><center><strong>2º Turno</strong></center></h1>"),
    br(), br(), br(), br(),
    column(width = 2),
    column(width = 4,
           btn_landing(texto = "Eleições Presidenciais",
                       cor = "#434aa8",
                       id = "btn_presidenciais")),
    column(width = 4,
           btn_landing(texto = "Eleições Estaduais",
                       cor = "#434aa8",
                       id = "btn_estaduais")),
    br()
  )