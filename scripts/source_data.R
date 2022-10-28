
source('functions/get_municipios_eleicoes.R')
source('functions/get_resultados_municipios.R')

mun <- get_municipios_eleicoes()

tictoc::tic("resultados 1o turno presidencial")

retorno_presidencial <- 
  mun %>%
  select(state,
         cod_mun_tse = cod_tse) %>% 
  mutate(
    cod_cargo = "0001",
    cod_eleicao = "544"
  ) %>% 
  group_split(state) %>% 
  purrr::map_df(
    .x = .,
    .f = function(x) {
      
      state = x %>% pull(state) %>% unique
      
      future::plan(future::multisession)
      
      tictoc::tic(paste0("data for state: ", state))
      
      df_ret <- 
        # purrr::pmap_df(x, get_resultados_municipios)
        furrr::future_pmap(x, get_resultados_municipios) %>% 
        bind_rows()
      
      readr::write_rds(df_ret, paste0("data/presidencial/", state, "_1o_turno.rds"))
      
      tictoc::toc()
      
      future::plan(future::sequential)
      
      return(df_ret)
      
    }  
  )

tictoc::toc()

readr::write_rds(retorno_presidencial, "data/presidencial/1o_turno_retorno_presidencial.rds")
