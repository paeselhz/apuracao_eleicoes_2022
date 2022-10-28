
source('functions/get_resultados_uf.R')
source('functions/get_resultados_br.R')
source('functions/get_municipios_eleicoes.R')

mun <- get_municipios_eleicoes()

retorno_presidencial_uf <-
  mun %>%
  select(state) %>% 
  distinct() %>% 
  mutate(
    cod_cargo = "0001",
    cod_eleicao = "544"
  ) %>% 
    purrr::pmap_df(
      get_resultados_uf
    )

retorno_presidencial_br <-
  get_resultados_br(cod_eleicao = "544")
