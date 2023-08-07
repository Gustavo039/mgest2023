library(gmailr)
##################




recivers_list = c(
  'g1@tvintegracao.com.br',
  'comunicacao@tvintegracao.com.br',
  'contato@grupointegração.com',
  'jornalismoalterosa@gmail.com',
  'contato@tvdiversa.com.br',
  'atendimento@radioglobojf.com.br',
  'juizdefora@redealeluia.com.br',
  'premiumnoticiasjf@gmail.com',
  'faleconosco@cbnjf.com.br',
  'fale.conosco@em.com.br'
)





###################

gm_auth_configure(path = 'C:/Users/Teste/AppData/Local/gmailr/gmailr/client_credentials.com.json')
gm_oauth_client()

###################

receivers_list = c('gustavoalmeidasilva@ice.ufjf.br',
                   'loltentativa@gmail.com')

recivers_df = data.frame(company_emails = receivers_list, 
                         send = rep(0,length(receivers_list)))

###################
if(0 %in% recivers_df$send == T){
  email_to_send =
    gm_mime() |>
    gm_to(recivers_df |> 
            dplyr::filter(send == 0) |>
            dplyr::select(company_emails) |>
            dplyr::pull()) |>
    gm_from("loltentativa@gmail.com") |>
    gm_subject("Divulgação MGEST2023 - UFJF") |>
    gm_text_body("Prezado(a) [Canal de TV/Emissora de Rádio]
  
  Por meio deste e-mail, a comissão de apoio do Encontro Mineiro de Estatística 2023 solicita gentilmente o seu apoio na divulgação deste evento para sua audiência.
  
  Nome do Evento: Encontro Mineiro de Estatística (MGEST)
  Data: 21 e 22 de setembro de 2023
  Local: Dept. Estatística, Instituto de Ciências Exatas, UFJF
  Site: https://sites.google.com/view/xvi-mgest-jf
  
  O Encontro Mineiro de Estatística (MGEST) é um evento científico organizado anualmente por instituições de ensino de Estatística do estado de Minas Gerais que, em 2023, se encontra em sua 16ª edição. Este ano, o MGEST será organizado pelo Departamento de Estatística da UFJF
  
  O MGEST é atualmente o maior congresso de Estatística realizado em Minas Gerais e procura congregar, além da comunidade Estatística do estado de Minas Gerais, também pesquisadores e estudantes de outros estados brasileiros. Tem sido um evento de caráter acadêmico de sucesso que congrega em torno de 300 participantes ao longo de 2 dias de intensas atividades.
  
  Para mais informações, parcerias de mídia ou credenciais para imprensa, entre em contato conosco através do e-mail [E-mail/Número de Telefone]. Nossa equipe terá prazer em ajudá-lo.
  
  Agradecemos a consideração de nossa proposta. 
  
  Atenciosamente, Comissão de Apoio MGEST 2023")
  
  gm_send_message(email_to_send)
  
  recivers_df = recivers_df |> 
    dplyr::mutate(send = 1)
}


