estaduais_ui <-
  tabPanel(
    title = "Eleições Estaduais",
    value = "estaduais",
    fluidRow(
      column(
        width = 3
      ),
      column(
        width = 9,
        radioGroupButtons(
          inputId = 'estaduais_estados',
          label = "",
          choices = estados_segundo_turno,
          selected = estados_segundo_turno %>% first()
        )
      )
    ),
    column(
      width = 3,
      progressBar(
        id = "progress_bar_estaduais",
        title = "Total de Seções Apuradas",
        value = 0,
        display_pct = TRUE
      ),
      p("Votos Válidos por Candidato"),
      uiOutput('lista_candidatos_estaduais')
    ),
    column(
      width = 9,
      leafletOutput('mapa_estados_estaduais',
                    height = "600px") %>%
        withSpinner()
    )
  )