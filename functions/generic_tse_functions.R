get_dados_cand <-
  function(cand_abr_tse) {
    
    result_cand <- 
      cand_abr_tse %>% 
      as_tibble() %>% 
      select(
        numero_partido = n,
        situacao = st,
        votos_validos_candidato = vap,
        perc_votos_validos_candidato = pvap
      )
    
    return(result_cand)
    
  }

get_dados_abr <-
  function(abr_tse, cod_mun_tse) {
    
    if(cod_mun_tse != abr_tse$cdabr) {
      
    } else {
      
      cand_abr <-
        purrr::map_df(
          abr_tse$cand,
          get_dados_cand
        )
      
      tbl_abr <-
        tibble(
          zona = abr_tse$cdabr,
          totalizacao_final = abr_tse$tf,
          secoes = abr_tse$s,
          secoes_totalizadas = abr_tse$st,
          perc_secoes_totalizadas = abr_tse$pst,
          eleitorado = abr_tse$e,
          perc_abstencao = abr_tse$pa,
          abstencao = abr_tse$a,
          votos_validos = abr_tse$vv,
          perc_votos_validos = abr_tse$pvv,
          cand_abr
        )
      
      return(
        tbl_abr
      )
      
    }
    
  }

codigos_cargo <-
  tibble::tibble(
    cargo = c(
      "0001",
      "0003",
      "0005",
      "0011",
      "0006",
      "0007",
      "0008",
      "0013"
    ),
    codigo = c(
      "Presidente",
      "Governador",
      "Senador",
      "Prefeito",
      "Deputado Federal",
      "Deputado Estadual",
      "Deputado Distrital",
      "Vereador"
    )
  )
