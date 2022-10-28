library(dplyr)

source('functions/generic_tse_functions.R')

get_resultados_br <-
  function(
    cod_eleicao
  ) {
    
    url_br <-
      paste0(
        "https://resultados.tse.jus.br/oficial/ele2022/",
        cod_eleicao,
        "/dados/br",
        "/br-c0001-e000",
        cod_eleicao, "-v.json"
      )
    
    return_tse_br <-
      httr::GET(
        url_br
      ) %>% 
      httr::content() %>% 
      .$abr %>% 
      magrittr::extract2(1)
    
    df_return_br <-
      get_dados_abr(
        return_tse_br,
        return_tse_br$cdabr
      ) %>% 
      mutate(
        mat_definido = return_tse_br$tf
      )
    
    return(df_return_br)
    
  }
