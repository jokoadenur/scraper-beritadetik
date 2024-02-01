# hapus environment
rm(list=ls())

# libraries
library(dplyr)
library(rvest)
library(stringr)
library(openxlsx)

# url awal
url = "https://www.detik.com/"

# ambil headline
headliner = 
  url %>% read_html() %>% html_nodes(".media__link") %>% html_text() %>% str_squish()

# buat nama file
nama_file = Sys.time() %>% as.character()
nama_file = paste0(nama_file,".xlsx")

# save headliner
write.xlsx(headliner,nama_file)
