presidenciais_ui <-
  tabPanel(
    title = "Eleições Presidenciais",
    value = "presidenciais",
    fluidRow(
      column(
        width = 3,
        radioGroupButtons(
          inputId = 'presidenciais_brasil_ou_estados',
          label = "",
          choices = c("Brasil" = "brasil", "Estados" = "estados"),
          selected = 'brasil'
        )
      ),
      column(
        width = 9,
        conditionalPanel(
          "input.presidenciais_brasil_ou_estados=='estados'",
          radioGroupButtons(
            inputId = 'presidenciais_estados',
            label = "",
            choices = municipios_eleicoes %>% pull(state) %>% unique() %>% sort(),
            selected = municipios_eleicoes %>% pull(state) %>% unique() %>% sort() %>% first()
          )
        )
        
      )
    ),
    column(
      width = 3,
      h3("Apuração Nacional"),
      progressBar(
        id = "progress_bar_brasil_presidenciais", 
        title = "Total de Seções Apuradas",
        value = 0, 
        display_pct = TRUE
      ),
      p("Votos Válidos por Candidato"),
      uiOutput('lista_candidatos'),
      conditionalPanel(
        "input.presidenciais_brasil_ou_estados=='estados'",
        uiOutput("title_apuracao_estado"),
        progressBar(
          id = "progress_bar_estados_presidenciais", 
          title = "Total de Seções Apuradas",
          value = 0, 
          display_pct = TRUE
        ),
        p("Votos Válidos por Candidato"),
        uiOutput('lista_candidatos_estados')
      )
    ),
    column(
      width = 9,
      leafletOutput('mapa_estados_presidenciais',
                    height = "600px") %>% 
        withSpinner()
    )
  )