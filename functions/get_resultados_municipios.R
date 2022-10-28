library(dplyr)

source('functions/generic_tse_functions.R')

get_resultados_municipios <-
  function(
    cod_mun_tse,
    cod_cargo,
    cod_eleicao,
    state
  ) {
    
    message(paste0("getting data for state ", state, " and mun ", cod_mun_tse))
    
    url_dados_mun <-
      paste0(
        "https://resultados.tse.jus.br/oficial/ele2022/",
        cod_eleicao,
        "/dados/",
        tolower(state),
        "/",
        tolower(state), #"rs87459-c0001-e000544-v.json"
        cod_mun_tse,"-c",
        cod_cargo, "-e000",
        cod_eleicao, "-v.json"
      )
    
    return_tse_municipio <-
      httr::GET(
        url_dados_mun
      ) %>% 
      httr::content()
    
    df_return_municipio <-
      purrr::map(
        return_tse_municipio$abr,
        get_dados_abr,
        cod_mun_tse = cod_mun_tse
      ) %>% 
      purrr::discard(is.null) %>% 
      magrittr::extract2(1) %>% 
      mutate(
        mat_definido = return_tse_municipio$md
      )
    
    return(df_return_municipio)
    
  }
