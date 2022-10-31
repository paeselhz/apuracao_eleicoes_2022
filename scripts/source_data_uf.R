# while(TRUE) {

source('functions/get_municipios_eleicoes.R')
source('functions/get_resultados_municipios.R')

mun <- get_municipios_eleicoes()

tictoc::tic("resultados 1o turno estadual")

mun %>%
  filter(state %in% c("AL", "AM", "BA", "ES", "MS", "PB", "PE", "RO", "RS", "SC", "SE", "SP")) %>% 
  select(state,
         cod_mun_tse = cod_tse) %>% 
  mutate(
    cod_cargo = "0003",
    cod_eleicao = "547"
  ) %>% 
  group_split(state) %>% 
  purrr::walk(
    .x = .,
    .f = function(x) {
      
      state = x %>% pull(state) %>% unique
      
      future::plan(future::multisession)
      
      tictoc::tic(paste0("data for state: ", state))
      
      df_ret <- 
        # purrr::pmap_df(x, get_resultados_municipios)
        furrr::future_pmap(x, get_resultados_municipios) %>% 
        bind_rows()
      
      readr::write_rds(df_ret, paste0("data/estadual/", state, "_2o_turno.rds"))
      
      tictoc::toc()
      
      future::plan(future::sequential)
      
      return(NA)
      
    }  
  )

tictoc::toc()

list.files(
  path = 'data/estadual',
  pattern = '2o_turno.rds',
  full.names = TRUE,
  recursive = TRUE
) %>% 
  purrr::map_df(
    readr::read_rds
  ) %>% 
  readr::write_rds(
    'data/estadual/2o_turno_retorno_estadual.rds'
  )


# }
