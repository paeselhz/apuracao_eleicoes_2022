resultados_br <-
  reactive({
    
    invalidateLater(10*1000, session = session)
    
    get_resultados_br(cod_eleicao = "545")
    
  })

resultados_uf <-
  reactive({
    
    invalidateLater(60*1000, session = session)
    
    # resultados_uf <-
    purrr::map_df(
      municipios_eleicoes %>% pull(state) %>% unique(),
      ~get_resultados_uf(state = .x, cod_eleicao = "545", cod_cargo = "0001")
    )
    
    
  })

resultados_municipios <-
  reactive({
    
    invalidateLater(5*60*1000, session = session)
    # resultados_municipios <-
    readr::read_rds(
      'data/presidencial/2o_turno_retorno_presidencial.rds'
    )
    
  })

observe({
  
  perc_totalizado <-
    resultados_br() %>% 
    pull(
      perc_secoes_totalizadas
    ) %>% 
    unique() %>% 
    stringr::str_replace(pattern = ",", replacement = "\\.") %>% 
    as.numeric()
  
  updateProgressBar(
    session = session, 
    id = "progress_bar_brasil_presidenciais", 
    value = perc_totalizado
  )  
  
})

observe({
  
  selected_state <-
    input$presidenciais_estados
  
  perc_totalizado <-
    resultados_uf() %>% 
    filter(
      zona == selected_state
    ) %>% 
    pull(
      perc_secoes_totalizadas
    ) %>% 
    unique() %>% 
    stringr::str_replace(pattern = ",", replacement = "\\.") %>% 
    as.numeric()
  
  updateProgressBar(
    session = session, 
    id = "progress_bar_estados_presidenciais", 
    value = perc_totalizado
  )  
  
})

output$title_apuracao_estado <-
  renderUI({
    h3(paste0("Apuração em ", input$presidenciais_estados))
  })


output$lista_candidatos <-
  renderUI({
    
    resultados_br() %>% 
      arrange(numero_partido) %>% 
      select(
        texto = numero_partido,
        percentual = perc_votos_validos_candidato,
        votos = votos_validos_candidato
      ) %>% 
      left_join(
        match_partidos,
        by = c('texto' = 'numero_partido')
      ) %>% 
      mutate(
        texto = paste0(partidos, " - ", texto),
        cor = '#d5d5d5',
        percentual = paste0(percentual, " %")
      ) %>% 
      select(-partidos) %>% 
      purrr::pmap(
        card_candidato
      ) %>% 
      tagList()
    
    
  })

output$lista_candidatos_estados <-
  renderUI({
    
    selected_state <-
      input$presidenciais_estados
    
    resultados_uf() %>% 
      filter(zona == selected_state) %>% 
      arrange(numero_partido) %>% 
      select(
        texto = numero_partido,
        percentual = perc_votos_validos_candidato,
        votos = votos_validos_candidato
      ) %>% 
      left_join(
        match_partidos,
        by = c('texto' = 'numero_partido')
      ) %>% 
      mutate(
        texto = paste0(partidos, " - ", texto),
        cor = '#d5d5d5',
        percentual = paste0(percentual, " %")
      ) %>% 
      select(-partidos) %>% 
      purrr::pmap(
        card_candidato
      ) %>% 
      tagList()
    
    
  })

output$mapa_estados_presidenciais <-
  renderLeaflet({
    
    if(input$presidenciais_brasil_ou_estados == 'brasil') {
      
      dados_tse_uf <-
        resultados_uf()
      
      mapa_estados %>% 
        left_join(
          dados_tse_uf %>% 
            arrange(zona, numero_partido) %>% 
            left_join(
              dados_tse_uf %>% 
                select(numero_partido) %>% 
                distinct() %>% 
                mutate(
                  generic = c('A', 'B')
                ),
              by = 'numero_partido'
            ) %>% 
            select(
              state = zona,
              perc_secoes_totalizadas,
              eleitorado,
              perc_abstencao,
              votos_validos,
              numero_partido,
              perc_votos_validos_candidato,
              votos_validos_candidato,
              generic
            ) %>% 
            left_join(
              match_partidos,
              by = 'numero_partido'
            ) %>% 
            tidyr::pivot_wider(
              names_from = generic,
              values_from = c(perc_votos_validos_candidato,
                              votos_validos_candidato,
                              numero_partido,
                              partidos, 
                              cor)
            ),
          by = c('abbrev_state' = 'state')
        ) %>% 
        mutate(
          cor_poligono = ifelse(perc_votos_validos_candidato_A >
                                  perc_votos_validos_candidato_B,
                                cor_A, cor_B)
        ) %>% 
        leaflet() %>% 
        addTiles() %>% 
        addPolygons(
          color = "grey",
          weight = 1,
          opacity = 1,
          fillColor = ~cor_poligono,
          fillOpacity = 0.65,
          label = ~abbrev_state,
          popup = 
            ~paste0(
              "<h4>", as.character(name_state), "</h4>",
              "<h5>Percentual de seções totalizadas: ", perc_secoes_totalizadas, "% </h5>",
              "<h5>Número de eleitores: ", eleitorado, "</h5>",
              "<h5>Percentual de abstenções: ", perc_abstencao, "% </h5>",
              "<hr>",
              "<h4>", partidos_A, " - ", numero_partido_A,": ", perc_votos_validos_candidato_A,"%</h4>",
              "<h4>", partidos_B, " - ", numero_partido_B,": ", perc_votos_validos_candidato_B,"%</h4>"
            )
        )
      
    } else {
      
      selected_state <-
        input$presidenciais_estados
      
      municipios_tse <-
        municipios_eleicoes %>% 
        filter(state == selected_state) %>% 
        select(cod_tse, cod_ibge) %>% 
        left_join(
          resultados_municipios(),
          by = c("cod_tse" = "zona")
        )  %>% 
        select(
          cod_tse,
          cod_ibge,
          perc_secoes_totalizadas,
          eleitorado,
          perc_abstencao,
          votos_validos,
          numero_partido,
          perc_votos_validos_candidato,
          votos_validos_candidato
        ) %>% 
        filter(
          perc_secoes_totalizadas != '0,00'
        )
      
      municipios_tse_new <-
        municipios_tse %>% 
        arrange(
          cod_ibge, numero_partido
        ) %>% 
        left_join(
          municipios_tse %>% 
            select(numero_partido) %>% 
            distinct() %>% 
            mutate(
              generic = c('A', 'B')
            ),
          by = 'numero_partido'
        ) %>% 
        left_join(
          match_partidos,
          by = 'numero_partido'
        ) %>% 
        arrange(numero_partido) %>% 
        tidyr::pivot_wider(
          names_from = generic,
          values_from = c(perc_votos_validos_candidato,
                          votos_validos_candidato,
                          numero_partido,
                          partidos, 
                          cor)
        )
      
      mapa_municipios %>% 
        filter(
          abbrev_state == selected_state
        ) %>% 
        mutate(
          code_muni = as.character(code_muni)
        ) %>% 
        left_join(
          municipios_tse_new,
          by = c("code_muni" = "cod_ibge")
        ) %>% 
        mutate(
          cor_poligono = ifelse(perc_votos_validos_candidato_A >
                                  perc_votos_validos_candidato_B,
                                cor_A, cor_B)
        ) %>%
        leaflet() %>% 
        addTiles() %>% 
        addPolygons(
          color = "grey",
          weight = 1,
          opacity = 1,
          fillColor = ~cor_poligono,
          fillOpacity = 0.65,
          label = ~name_muni,
          popup = 
            ~paste0(
              "<h4>", as.character(name_muni), " - ", as.character(abbrev_state), "</h4>",
              "<h5>Percentual de seções totalizadas: ", perc_secoes_totalizadas, "% </h5>",
              "<h5>Número de eleitores: ", eleitorado, "</h5>",
              "<h5>Percentual de abstenções: ", perc_abstencao, "% </h5>",
              "<hr>",
              "<h4>", partidos_A, " - ", numero_partido_A,": ", perc_votos_validos_candidato_A,"%</h4>",
              "<h4>", partidos_B, " - ", numero_partido_B,": ", perc_votos_validos_candidato_B,"%</h4>"
            )
        )
      
    }
    
  })
