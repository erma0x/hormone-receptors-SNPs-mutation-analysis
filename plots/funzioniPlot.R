"
Funzioni per plottare i grafici:
  -Instogramma
  -stackedhist
  -PieChartFunction
"


# LIB ##################################################################################################
library(reshape2)
source(lib.R)
librerie()
source(funzioni.R)

##################################################################################################
Instogramma<-function(Nomegene,Addition,Change,Match,Delition,BINWIDTH=1)
  {
  "
Funzione creata per la visualizzazione della frequenza
delle posizioni dei diversi SNPs, lungo un unico gene.
  "

  
bucket<-list(change=Change,addition=Addition,delition=Delition,match=Match)

PLOT<-ggplot(melt(bucket), aes(value, fill = L1)) +  # estetics
  
  geom_histogram(position = "stack", binwidth=BINWIDTH)+ # HIST PLOT
  
  labs(title = c("Frequenza di SNPs lungo il gene"), # TITLE 
       subtitle =   c(Nomegene) , # SUBTITLE
     
       x = " Posizione Gene ", # XLAB
       
       y = "Frequenza") # YLAB

PLOT + guides(fill = guide_legend(title = "SNPs Types ")) # LEGEND

   }

# ESEMPIO utilizzo funzione

#a=c(2:6) # 1* vettore
#b=c(5:8) # 2* vettore
#c=c(1:5) # 3* vettore
#d=c(1:5) # 4* vettore
#titolo = 'Androgene Receptor'
# BINWIDTH = 1
#Instogramma(titolo ,a ,b ,c ,d ,BINWIDTH) 

##################################################################################################

stackedhist <- function(nomeFileDati , nomeGene, binwithd){
  "
  
  StackedInstogram prende in input il nome del file ex. 'nomeFile.csv'
  Guarda dentro il file, filtra per tipologia di SNPs
  
  "
  
  print(" File dati csv deve essere con:
  
              | count.SNPs_PFM.SNPID. | SNP_PFM.type |  
        
        Guardare le query in SQL Numero 26 per maggiori chiarimenti 
        
        ")
  
  file=ClearFromSpace(fileDirectory,nomeFileDati)
  v<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)
  
  delition<-filter(v, v[2]=='delition') %>% select(count.SNPs_PFM.SNPID.)
  addition<-filter(v, v[2]=='addition') %>% select(count.SNPs_PFM.SNPID.)
  change<-filter(v, v[2]=='change') %>% select(count.SNPs_PFM.SNPID.)
  match<-filter(v, v[2]=='match') %>% select(count.SNPs_PFM.SNPID.)
  
  Instogramma(Nomegene = nomeGene,
              Addition = addition,
              Delition = delition,
              Change = change,
              Match = match,
              BINWIDTH = binwithd)
  
  
}



##################################################################################################

PieChartFunction <- function(DataFileName="dati26_AR.csv",ChartFileName="pie_chart0.png",NameGene="Androgene Receptor")
{" 
   Disegna un pieChart con le proporzioni dei diversi tipi di SNPs
   Salvando l' immagine come .png
  "
  file=ClearFromSpace(fileDirectory,DataFileName)
  v <- read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)
  
  delition_SNPsCount <-subset(v, SNPs_PFM.type=='delition', select = count.SNPs_PFM.SNPID.)
  addition_SNPsCount <-subset(v, SNPs_PFM.type=='addition', select = count.SNPs_PFM.SNPID.)
  change_SNPsCount <-subset(v, SNPs_PFM.type=='change', select = count.SNPs_PFM.SNPID.)
  match_SNPsCount <-subset(v, SNPs_PFM.type=='match', select = count.SNPs_PFM.SNPID.)
  
  labels <- c("match", "change", "addition", "delition")
  
  png(file = ChartFileName)
  
  all<-c(delition_SNPsCount,addition_SNPsCount,change_SNPsCount,match_SNPsCount)
  
  pie(a, labels, main = paste("SNPs type in",NameGene), col = rainbow(length(x)))
  
  dev.off() # save file
  
  print(paste(" Pie chart salvato di ",NameGene )) # OUTPUT
}








