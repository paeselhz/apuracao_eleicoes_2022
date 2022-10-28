library(dplyr)

get_municipios_eleicoes <-
  function(cod_eleicoes = "544", with_z = F) {
    
    mun_url <- paste0(
      "https://resultados.tse.jus.br/oficial/ele2022/", 
      cod_eleicoes, 
      "/config/mun-e000", 
      cod_eleicoes,
      "-cm.json"
    )
    
    municipios <- 
      httr::GET(
        mun_url
      ) |> 
      httr::content() %>%
      .$abr |> 
      purrr::map_df(
        function(x) {
          
          state <- x$cd
          state_name <- x$ds
          
          ret_df <-
            purrr::map_df(
              x$mu,
              function(y) {
                
                dplyr::as_tibble(y) |> 
                  tidyr::unnest(cols = c(z))
                
              }
            ) %>% 
            rename(
              zona = z,
              is_capital = c,
              cod_ibge = cdi,
              cod_tse = cd,
              nm_municipio = nm
            ) %>% 
            mutate(
              state = state,
              nm_state = state_name
            ) %>% 
            relocate(c(state, nm_state), .before = "cod_tse") %>% 
            filter(
              cod_ibge != ""
            )
          
          if(with_z) {
            
            message("Tabela com zonas, pode haver municipios duplicados!")
            
          } else {
            
            ret_df <-
              ret_df %>% 
              select(
                state,
                nm_state,
                cod_tse,
                cod_ibge,
                nm_municipio,
                is_capital
              ) %>% 
              distinct()
            
          }
          
          return(ret_df)
          
        }
      )
    
    return(municipios)
    
  }
