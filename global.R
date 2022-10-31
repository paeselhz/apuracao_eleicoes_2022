# library(DT)
library(sf)
library(shiny)
library(dplyr)
library(leaflet)
library(shinyWidgets)
library(shinycssloaders)

source('functions/get_resultados_br.R')
source('functions/get_resultados_uf.R')
source('functions/get_municipios_eleicoes.R')

mapa_estados <-
  readr::read_rds('data/shapefiles/estados_br.rds')

mapa_municipios <-
  readr::read_rds('data/shapefiles/cidades_br.rds')

municipios_eleicoes <-
  # get_municipios_eleicoes(cod_eleicoes = "544")
  readr::read_rds('data/municipios_eleicoes.rds')

match_partidos <-
  readr::read_rds('data/match_partidos.rds')

estados_segundo_turno <-
  readr::read_rds('data/estadual/1o_turno_retorno_estadual.rds') %>% 
  filter(situacao == "2º turno") %>% 
  select(zona) %>% 
    left_join(
      municipios_eleicoes %>% 
        select(state, cod_tse),
      by = c('zona' = 'cod_tse')
    ) %>% 
    pull(state) %>% 
    unique()

btn_landing <-
  function(texto, cor, id) {
    HTML(
      paste0(
        '<a id="', id,'" href="#" class="action-button">
                  <div class = "tab-block-landing tab-block" style = "background-color:', cor, ';"> 
                  <span class = "name">', texto, '</span>
                  </div>
        </a>'
      )
    )
  }

card_candidato <-
  function(texto, cor, percentual, votos){ # id, url) {
    
    # <img src = "https://divulgacandcontas.tse.jus.br/candidaturas/oficial/2022/BR/BR/544/candidatos/899992/foto.jpg">
    HTML(
      paste0(
        '<div class = "tab-block-landing tab-block" style = "background-color:', cor, ';"> 
        <span class = "name">', texto, '</span>
        <span class = "perc">', percentual,'</span> <br>
        <span class = "votos">', formatC(as.numeric(votos), format="d", big.mark="\\.", digits=0), '</span>
        </div>'
      )
    )
    
  }

ui_files <-
  list.files(
    path = "tabs",
    pattern = "*_ui",
    recursive = TRUE,
    full.names = TRUE
  )

purrr::walk(ui_files, ~source(.x))
