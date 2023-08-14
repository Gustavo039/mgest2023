
suppressMessages(library(RSelenium))
suppressMessages(library(netstat))
suppressMessages(library(rvest))

rs_driver_object <- rsDriver(browser = 'chrome',
                             chromever = '114.0.5735.90',
                             verbose = FALSE,
                             port = free_port(random=T))

# create a client object
remDr <- rs_driver_object$client

# open a browser and going to datasus_srag web page
remDr$navigate("https://www.booking.com/city/br/juiz-de-fora.pt.html?aid=1702940;label=juiz-de-fora-BPEcpQwm0f2TISeNCRUMywS383513189256:pl:ta:p1:p2:ac:ap:neg:fi:tikwd-415409152295:lp9101186:li:dec:dm:ppccp=UmFuZG9tSVYkc2RlIyh9YcpDr58xwogAwmVmCRFhsnQ;ws=&gad=1&gclid=Cj0KCQjwoeemBhCfARIsADR2QCuvMCH-xCFLuxhWzb1XKsl6Wu65k_FQw_3_nCCgnr3wFxQYeI0VSnkaAur4EALw_wcB")
hotel_name = sapply(1:10,function(i){
  step_obj = remDr$findElement(using = "xpath",
                    sprintf('//*[@id="skipto_main"]/div[4]/div[%i]/div[2]/div[1]/div[1]/header/a/h3/span[1]', i))
  return(step_obj$getElementText())
})

hotel_price = sapply(1:10,function(i){
  step_obj = remDr$findElement(using = "xpath",
                               sprintf('//*[@id="skipto_main"]/div[4]/div[%i]/div[2]/div[1]/div[2]/div[2]/div/div[2]', i))
  return(step_obj$getElementText())
})

booking_avaliation = sapply(1:10,function(i){
  step_obj = remDr$findElement(using = "xpath",
                               sprintf('//*[@id="skipto_main"]/div[4]/div[%i]/div[2]/div[1]/div[2]/div[1]/div[1]', i))
  return(step_obj$getElementText())
})
  

hotel_name = hotel_name |> unlist()
hotel_price = hotel_price |> unlist()
booking_avaliation = booking_avaliation |> unlist()

df_hotels = data.frame(hotel_name, hotel_price, booking_avaliation)

write.csv(df_hotels, 'D:/UFJF_materias/mgest2023/hotels_jf.csv')


