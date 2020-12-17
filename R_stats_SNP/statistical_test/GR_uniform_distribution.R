set.seed(0)

fileDirectory='/home/user/Desktop/Tirocinio/ScriptR/SNP_unif_distribution'
setwd(fileDirectory)

source(funzioni.R)
source(funzioniPlot.R)
######################################################################################################
"
    Testa la ditrubuzione degli SNPs lungo il gene
    Se gli SNP sono distribuiti in maniera uniforme come frequenza in Bins(o 'chunks')
    lungo tutto il gene. Per calcolare la lunghezza del gene prendo il la posizione dello SNP.
    Posso poi vedere se la distribuzione e' uniforme lungo il gene. Per vedere la lunghezza totale
    del gene, mi affido alla posizione massima e minima degli SNPs trovati in quel gene.
    
       QUERY al Database numero 26_GR
  
    query_26_GR <-paste('select SNPs.pos 
    FROM ((SNPs_PFM INNER JOIN PFM ON (SNPs_PFM.PFMID=PFM.PFMID))
    INNER JOIN SNPs ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE ( (SNPs_PFM.type IN ',lista_type,') AND
    PFM.PFMID IN ( SELECT PFMID FROM PFM_GeneSymbols WHERE GENESYMBOLID == 1055 );')
"
# TEST 
# H0 distribuzione Freq == ~ distribuzione Uniforme(p = p0 ) 
# H1 distribuzione Freq SNP !~ distribuzione Uniforme

path='/home/user/Desktop/' # <- SET THE PATH
setwd(path)

data <- read.csv('Tirocinio/Data/dati_26_GR.csv', header = TRUE) # read data
hist.output = hist(data, breaks = 4) # divide into bins
real=hist.output$counts # take counts 
theor <-runif( length(data), min(data), max(data))
chisq.test (real,theor)





