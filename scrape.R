# hapus environment
rm(list=ls())

# libraries
library(dplyr)
library(rvest)

# url awal
url = "https://www.detik.com/"

# ambil headline
headliner = 
  url %>% 
  read_html() %>% 
  html_nodes(".media__link") %>% 
  html_text(trim = T)

# buat nama file
nama_file = Sys.time() %>% as.character()
nama_file = paste0(nama_file,".csv")

# save headliner
write.csv(headliner,nama_file)
