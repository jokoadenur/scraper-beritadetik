# hapus environment
rm(list=ls())

# libraries
library(readxl)
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

# Baca data yang sudah ada
sebelum <- read_excel("beritadetikjatim.xlsx")

# Gabungkan data hasil scraping dengan data yang sudah ada sebelumnya
update <- rbind(sebelum, detikjatim)

# hapus duplikasi
update2 <- distinct(update)

# ekstraksi tgl dan ubah menjadi date
ekstrak_tgl <- function(x) {
  tanggal <- regmatches(x, regexpr("\\d{2} [A-Za-z]+ \\d{4}", x))
  tanggal <- as.Date(tanggal, format = "%d %b %Y")
  tanggal <- format(tanggal, "%Y-%m-%d")
  return(tanggal)
}

# Menerapkan fungsi pada kolom waktu
update2$tgl <- sapply(update2$tgl, ekstrak_tgl)

# urutkan tgl
update2 <- arrange(update2)

# Simpan data update ke file xlsx yang sama
write.xlsx(update2, "beritadetikjatim.xlsx", row.names = FALSE)
