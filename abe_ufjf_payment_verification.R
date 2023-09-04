setwd('D:/UFJF_materias/mgest2023')
#############
lista_ufjf = readxl::read_xlsx('./files/lista_ufjf.xlsx', skip = 1) |>
  janitor::clean_names() |>
  dplyr:: mutate(nome_completo = stringr::str_to_upper(nome_completo))

lista_abe = readxl::read_xlsx('./files/lista_abe.xlsx') |>
  janitor::clean_names() |>
  dplyr::rename(nome_completo = nome) |>
  dplyr:: mutate(nome_completo = stringr::str_to_upper(nome_completo))


lista_diff_abe = dplyr::anti_join(lista_abe, lista_ufjf, by = 'nome_completo')
lista_diff_ufjf = dplyr::anti_join(lista_ufjf, lista_abe, by = 'nome_completo')
############

lista_abe_npago = lista_abe |>
  dplyr::filter(is.na(valor_pago))

lista_ufjf_npago = lista_ufjf |>
  dplyr::filter(is.na(x5) & is.na(x6))

lista_diff_npago = dplyr::inner_join(lista_abe_npago, lista_ufjf |>
                                       dplyr::filter(x5 == T | x6 == T), 
                                     by = 'nome_completo')
  lista_diff_npago = lista_diff_npago[,c(1,2,3,4)]

###################

lista_poster = readxl::read_xlsx('./files/lista_poster.xlsx') |>
  janitor::clean_names() |>
  dplyr:: mutate(nome_completo = stringr::str_to_upper(primeiro_autor), 
                 .keep = 'unused') 


lista_diff_npago_abe = dplyr::inner_join(lista_abe_npago, lista_poster,
                                         by = 'nome_completo') 
    lista_diff_npago_abe = lista_diff_npago_abe[,c(1,2,3,4,10)]

lista_diff_npago_ufjf = dplyr::inner_join(lista_ufjf_npago, lista_poster,
                                         by = 'nome_completo')
    lista_diff_npago_ufjf = lista_diff_npago_ufjf[, c(1,2,3,4,8)]
################

write.csv(lista_diff_npago, 'D:/UFJF_materias/mgest2023/nao_pagos_abe.csv')
write.csv(lista_diff_npago_abe, 'D:/UFJF_materias/mgest2023/poster_nao_pagos_abe.csv')
write.csv(lista_diff_npago_ufjf, 'D:/UFJF_materias/mgest2023/poster_nao_pagos_ufjf.csv')





  
