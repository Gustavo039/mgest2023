library(pdftools)
setwd('D:/UFJF_materias/mgest2023')
pdf_folder = list.files("./payment_folder")

#Bank Selection ###########################

banco_do_brasil_option = function(pdf_size){
  reference = pdftools::pdf_pagesize(paste("./payment_folder/", pdf_folder[6], sep = ''))
  check = NA
  if(identical(pdf_size, reference) == T)
      check = 'banco_do_brasil'
  return(check)
}

bradesco_option = function(pdf_size){
  reference = pdftools::pdf_pagesize(paste("./payment_folder/", pdf_folder[2], sep = ''))
  check = NA
  if(identical(pdf_size, reference))
    check = 'bradesco'
  return(check)
}  

caixa_option = function(pdf_size){
  reference = pdftools::pdf_pagesize(paste("./payment_folder/", pdf_folder[3], sep = ''))
  check = NA
  if(identical(pdf_size, reference))
    check = 'caixa'
  return(check)
}

santander_option = function(pdf_size){
  reference = pdftools::pdf_pagesize(paste("./payment_folder/", pdf_folder[1], sep = ''))
  check = NA
  if(identical(pdf_size, reference) == T) {
    check = 'santander'
  }
  return(check)
}

bank_option = function(raw_data){
  bank_choice = vector()
    for(i in 1:4){
      bank_choice[1] = banco_do_brasil_option(raw_data)
      bank_choice[2] = bradesco_option(raw_data)
      bank_choice[3] = caixa_option(raw_data)
      bank_choice[4] = santander_option(raw_data)
    }
   ret = na.omit(bank_choice) |>
     {\(x) return(x[1])}()
  return(ret)
}

#########################################

banco_do_brasil_payment_check = function(pdf_data_recive){
  payment_string = pdf_data_recive
  
  payer_name <- regmatches(payment_string, regexpr("CLIENTE:\\s+(.*?)\\n", payment_string))
  payer_name = gsub("CLIENTE: ", "", payer_name)
  
  payment_date <- regmatches(payment_string, regexpr("DATA:\\s+(.*?)\\n", payment_string))
  date_pattern <- "\\d{2}/\\d{2}/\\d{4}"
  payment_date <- regmatches(payment_date, regexpr(date_pattern, payment_date))
  
  payment_amount <- as.numeric(gsub("[^0-9.]", "", regmatches(payment_string, regexpr("VALOR:\\s+(\\d+,\\d{2})", payment_string))))
  
  return(data.frame('payer_name' = payer_name,
                    'payment_amount' = payment_amount,
                    'payment_date' = payment_date) |>
           head(1))
}

santander_payment_check = function(pdf_data_recive){
  payment_string = pdf_data_recive
  
  # Extract payment date
  payment_date = regmatches(payment_string, regexpr("\\d{2}/\\d{2}/\\d{4}", payment_string))
  
  # Extract payment amount
  reais_pattern = "Valor pago[\\s\\S]*?R\\$\\s*([0-9,.]+)"
  reais_matches = regmatches(payment_string, gregexpr(reais_pattern, payment_string, perl = TRUE))
  payment_amount = as.numeric(gsub("[^0-9.]", "", reais_matches))
  
  # Extract payer's name
   payer_name = regmatches(payment_string, regexpr("De\\n(.*?)\\nCPF", payment_string))[[1]] 
   payer_name = gsub("De\\n|\\nCPF", "", payer_name)
  
  return(data.frame('payer_name' = payer_name,
              'payment_amount' = payment_amount,
              'payment_date' = payment_date) |>
           head(1))
}


bradesco_payment_check = function(pdf_data_recive){
  payment_string = pdf_data_recive
  
  payment_date <- regmatches(payment_string, regexpr("Data e Hora: (.*?)\\n", payment_string))
  date_pattern <- "\\d{2}/\\d{2}/\\d{4}"
  payment_date <- regmatches(payment_date, regexpr(date_pattern, payment_date))
  
  payer_name <- regmatches(payment_string, regexpr("Nome: (.*?)\\n", payment_string))
  payer_name = gsub("Nome: ", "", payer_name)
  
  payment_amount <- as.numeric(gsub("[^0-9.]", "", regmatches(payment_string, regexpr("Valor: R\\$ (\\d+,\\d{2})", payment_string))))

  return(data.frame('payer_name' = payer_name,
                    'payment_amount' = payment_amount,
                    'payment_date' = payment_amount) |>
           head(1))
}  



payment_check =  function(bank_recive, pdf_data){
  switch (bank_recive,
    'santander' = santander_payment_check(pdf_data),
    'banco_do_brasil' = banco_do_brasil_payment_check(pdf_data),
    'bradesco' = bradesco_payment_check(pdf_data)
  )
}


    
  

############################



lapply(1:length(pdf_folder), function (i){
  pdf_pagesize = pdftools::pdf_pagesize(paste("./payment_folder/", pdf_folder[i], sep = ''))
  pdf_text = pdftools::pdf_text(paste("./payment_folder/", pdf_folder[i], sep = ''))
  pdf_pagesize  |>
     bank_option() |>
     payment_check(pdf_text)
    
})


pdftools::pdf_pagesize(paste("./payment_folder/", pdf_folder[2], sep = '')) |>
  bank_option()
