"
 Funzine per gestire le librerie per il file principarle 
 
"
librerie<-function(){
  if(!require(stringr)) install.packages("stringr")
  library(stringr)
  
  if(!require(dplyr)) install.packages("dplyr")
  library(dplyr)

  if(!require(DBI)) install.packages("DBI")
  library(DBI)
  
  if(!require(RMySQL)) install.packages("RMySQL")
  library(RMySQL)
  
  if(!require(ggplot2)) install.packages("ggplot2")
  library(ggplot2)
  
  if(!require(devtools)) install.packages("devtools")
  library(devtools)
  
  if(!require(glue)) install.packages("glue")
  library(glue)
  
  if(!require(configr)) install.packages("configr")
  library(configr)
  
  print("Librerie caricate")
}

setRepo<- function()
  {
  setRepositories(graphics = getOption("menu.graphics"),
                  ind = NULL, addURLs = character())
  }


# packageDescription("Nome Pacchetto") # for 
# help(package = "nome Pacchetto")
