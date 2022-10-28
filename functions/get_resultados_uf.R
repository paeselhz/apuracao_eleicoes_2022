library(dplyr)

source('functions/generic_tse_functions.R')

get_resultados_uf <-
  function(
    cod_eleicao,
    cod_cargo,
    state
  ) {
    
    url_uf <-
      paste0(
        "https://resultados.tse.jus.br/oficial/ele2022/",
        cod_eleicao,
        "/dados/",
        tolower(state),
        "/",
        tolower(state), "-c",
        cod_cargo, "-e000",
        cod_eleicao, "-v.json"
      )
    
    return_tse_uf <-
      httr::GET(
        url_uf
      ) %>% 
      httr::content() %>% 
      .$abr %>% 
      magrittr::extract2(1)
    
    df_return_uf <-
      get_dados_abr(
        return_tse_uf,
        return_tse_uf$cdabr
      ) %>% 
      mutate(
        mat_definido = return_tse_uf$tf
      )
    
    return(df_return_uf)
    
  }
