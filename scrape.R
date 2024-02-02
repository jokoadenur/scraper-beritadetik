# hapus environment
rm(list=ls())

# libraries
library(dplyr)
library(rvest)
library(stringr)
library(openxlsx)

dptisi <- function(x){
  isi <- read_html(x)
  isiku <- isi %>% html_nodes('.itp_bodycontent h2 , p') %>% html_text() %>% paste(collapse = " ")
  return(isiku)
}

detikjatim <- data.frame()

for(hasil in seq(from = 1, to = 2, by = 1)){
  url <-paste0("https://www.detik.com/search/searchall?query=Jatim&siteid=2&sortby=time&page=", hasil)
  laman <- read_html(url)
 
  judul <- laman %>% html_nodes('span .title') %>% html_text()
  tgl <- laman %>% html_nodes('span .date') %>% html_text()
  link_judul <- laman %>% html_nodes('.list-berita a') %>% html_attr("href")
 
  isiberita <- sapply(link_judul, FUN = dptisi, USE.NAMES = F)
 
  detikjatim <- rbind(detikjatim, data.frame(judul, tgl, isiberita, link_judul, stringsAsFactors = F))
  print(paste("page ke-", hasil))
}

# buat nama file
nama_file = Sys.time() %>% as.character()
nama_file = paste0(nama_file,".xlsx")

# save headliner
write.xlsx(detikjatim,nama_file)
