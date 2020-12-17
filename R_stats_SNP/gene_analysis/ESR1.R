########## Variabili & Funzioni ##################
"
Confronto degli Score: (ScoreAlt - ScoreRef) / MaxScore
Confronto che avviene solo per i geni di interesse 
ed un dato un elemento funzionale alla volta. 
Vengono confrontate due linee cellulari contemporaneamente,
attraverso l'uso di una funzione BoxPlot,
prendendo lo stesso gene e lo stesso elemento funzionale.
"
library(RMySQL)
library(ggplot2)
library(plyr)
library(devtools)

source(file ="./modules/lib.R")
librerie()
source(file ="./modules/funzioni.R")
source(file="./modules/funzioniPlot.R")
source(file ="./modules/var.R",local = T)
setwd(fileDirectory) # DA RISETTARE

###############################################################################
# Estrogen Receptor 1  
###############################################################################
Seno_EnhancerOFF_ESR1<-paste("select (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore)
                 FROM  (( SNPs_FunctionalElement INNTER JOIN SNPs
                 ON SNPs_FunctionalElement.SNPID=SNPs.SNPID)
                 INNER JOIN SNPs_PFM ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE
                 SNPs.SNPID IN (select SNPs_PFM.SNPID from SNPs_PFM LEFT JOIN
                 PFM_GeneSymbols ON (PFMID)
                 WHERE PFM_GeneSymbols_GENESYMBOLID=401 and SNPs_PFM.type='match'
                 group by SNPs_PFM.SNPID )
                 AND SNPs_FunctionalElement.fileType='broad' AND ",SNP_FE[1],"
                 AND SNPs_FunctionalElement.CELLINEID=",IDcellLine_Cancro_al_SENO,"
                 GROUP BY SNPs.SNPID ORDER BY (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore) DESC;")
Save(DataBase = db,query = Seno_EnhancerOFF_ESR1,fileName = 'Seno_EnhancerOFF_ESR1.csv')

Seno_EnhancerON_ESR1<-paste("select (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore)
                 FROM  (( SNPs_FunctionalElement INNTER JOIN SNPs
                 ON SNPs_FunctionalElement.SNPID=SNPs.SNPID)
                 INNER JOIN SNPs_PFM ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE
                 SNPs.SNPID IN (select SNPs_PFM.SNPID from SNPs_PFM LEFT JOIN
                 PFM_GeneSymbols ON (PFMID)
                 WHERE PFM_GeneSymbols_GENESYMBOLID=401 and SNPs_PFM.type='match'
                 group by SNPs_PFM.SNPID )
                 AND SNPs_FunctionalElement.fileType='broad' AND ",SNP_FE[2],"
                 AND SNPs_FunctionalElement.CELLINEID=",IDcellLine_Cancro_al_SENO,"
                 GROUP BY SNPs.SNPID ORDER BY (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore) DESC;")
Save(DataBase = db,query = Seno_EnhancerON_ESR1,fileName = 'Seno_EnhancerON_ESR1.csv')

Seno_Promoter_ESR1<-paste("select  (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore)
                 FROM  (( SNPs_FunctionalElement INNTER JOIN SNPs
                 ON SNPs_FunctionalElement.SNPID=SNPs.SNPID)
                 INNER JOIN SNPs_PFM ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE
                 SNPs.SNPID IN (select SNPs_PFM.SNPID from SNPs_PFM LEFT JOIN
                 PFM_GeneSymbols ON (PFMID)
                 WHERE PFM_GeneSymbols_GENESYMBOLID=401 and SNPs_PFM.type='match'
                 group by SNPs_PFM.SNPID )
                 AND SNPs_FunctionalElement.fileType='broad' AND ",SNP_FE[3],"
                 AND SNPs_FunctionalElement.CELLINEID=",IDcellLine_Cancro_al_SENO,"
                 GROUP BY SNPs.SNPID ORDER BY (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore) DESC;")
Save(DataBase = db,query = Seno_Promoter_ESR1,fileName = 'Seno_Promoter_ESR1.csv')

## PROSTATA
Prostata_EnhancerOFF_ESR1<-paste("select   (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore)
                 FROM  (( SNPs_FunctionalElement INNTER JOIN SNPs
                 ON SNPs_FunctionalElement.SNPID=SNPs.SNPID)
                 INNER JOIN SNPs_PFM ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE
                 SNPs.SNPID IN (select SNPs_PFM.SNPID from SNPs_PFM LEFT JOIN
                 PFM_GeneSymbols ON (PFMID)
                 WHERE PFM_GeneSymbols_GENESYMBOLID=401 and SNPs_PFM.type='match'
                 group by SNPs_PFM.SNPID )
                 AND SNPs_FunctionalElement.fileType='broad' AND ",SNP_FE[1],"
                 AND SNPs_FunctionalElement.CELLINEID=",IDcellLine_Cancro_alla_PROSTATA,"
                 GROUP BY SNPs.SNPID ORDER BY (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore) DESC;")
Save(DataBase = db,query = Prostata_EnhancerOFF_ESR1,fileName = 'Prostata_EnhancerOFF_ESR1.csv')

Prostata_EnhancerON_ESR1<-paste("select  (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore)
                 FROM  (( SNPs_FunctionalElement INNTER JOIN SNPs
                 ON SNPs_FunctionalElement.SNPID=SNPs.SNPID)
                 INNER JOIN SNPs_PFM ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE
                 SNPs.SNPID IN (select SNPs_PFM.SNPID from SNPs_PFM LEFT JOIN
                 PFM_GeneSymbols ON (PFMID)
                 WHERE PFM_GeneSymbols_GENESYMBOLID=401 and SNPs_PFM.type='match'
                 group by SNPs_PFM.SNPID )
                 AND SNPs_FunctionalElement.fileType='broad' AND ",SNP_FE[2],"
                 AND SNPs_FunctionalElement.CELLINEID=",IDcellLine_Cancro_alla_PROSTATA,"
                 GROUP BY SNPs.SNPID ORDER BY (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore) DESC;")
Save(DataBase = db,query = Prostata_EnhancerON_ESR1,fileName = 'Prostata_EnhancerON_ESR1.csv')

Prostata_Promoter_ESR1<-paste("select (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore)
                 FROM  (( SNPs_FunctionalElement INNTER JOIN SNPs
                 ON SNPs_FunctionalElement.SNPID=SNPs.SNPID)
                 INNER JOIN SNPs_PFM ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE
                 SNPs.SNPID IN (select SNPs_PFM.SNPID from SNPs_PFM LEFT JOIN
                 PFM_GeneSymbols ON (PFMID)
                 WHERE PFM_GeneSymbols_GENESYMBOLID=401 and SNPs_PFM.type='match'
                 group by SNPs_PFM.SNPID )
                 AND SNPs_FunctionalElement.fileType='broad' AND ",SNP_FE[3],"
                 AND SNPs_FunctionalElement.CELLINEID=",IDcellLine_Cancro_alla_PROSTATA,"
                 GROUP BY SNPs.SNPID ORDER BY (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore) DESC;")
Save(DataBase = db,query = Prostata_Promoter_ESR1,fileName = 'Prostata_Promoter_ESR1.csv')

##########                          ################
########## BOX PLOT ENHANCER OFF ESR1 ################

file=ClearFromSpace(fileDirectory,'Seno_EnhancerOFF_ESR1.csv')
Seno_EnhancerOFF_ESR1<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

file=ClearFromSpace(fileDirectory,'Prostata_EnhancerOFF_ESR1.csv')
Prostata_EnhancerOFF_ESR1<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

boxPlot <- boxplot(Seno_EnhancerOFF_ESR1,
                   Prostata_EnhancerOFF_ESR1,notch = TRUE,xticks=c('a','b'),
                   main=" Estrogen Receptor 1 con SNPs in EnhancerOFF ",
                   sub=" Grado di alterazione degli SNPs fra cancro al seno e linea cellulare del cancro alla prostata ",
                   xlab=" Linea Cellulare ",
                   ylab=" ( ScoreAlt - ScoreRef ) / MaxScore",
                   col="orange",
                   border="blue")
axis(side = 1,at = 1:2,labels=c("Cancro al Seno", "Cancro alla Prostata"),lwd.ticks = FALSE)
png(filename="Seno/Prostata_EnhancerOFF_ESR1.png")
plot(boxPlot)
dev.off()

########## BOX PLOT ENHANCER ON ESR1 ################

file=ClearFromSpace(fileDirectory,'Seno_EnhancerON_ESR1.csv')
Seno_EnhancerON_ESR1<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

file=ClearFromSpace(fileDirectory,'Prostata_EnhancerON_ESR1.csv')
Prostata_EnhancerON_ESR1<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

boxPlot <- boxplot(Seno_EnhancerON_ESR1,
                   Prostata_EnhancerON_ESR1,notch = TRUE,
                   main=" Estrogene Receptor 1 con SNPs in EnhancerON ",
                   sub=" Grado di alterazione degli SNPs fra cancro al seno e linea cellulare del cancro alla prostata ",
                   xlab=" Linea Cellulare ",
                   ylab=" ( ScoreAlt - ScoreRef ) / MaxScore",
                   col="black",
                   border="yellow")
axis(side = 1,at = 1:2,labels=c("Cancro al Seno", "Cancro alla Prostata"),lwd.ticks = FALSE)
png(filename="Seno/Prostata_EnhancerON_ESR1.png")
plot(boxPlot)
dev.off()

########## BOX PLOT PROMOTER ESR1 ################
file=ClearFromSpace(fileDirectory,'Seno_EnhancerOFF_ESR1.csv')
Seno_EnhancerOFF_ESR1<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

file=ClearFromSpace(fileDirectory,'Prostata_EnhancerOFF_ESR1.csv')
Prostata_EnhancerOFF_ESR1<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

boxPlot <- boxplot(Seno_EnhancerOFF_ESR1,
                   Prostata_EnhancerOFF_ESR1,notch = TRUE,
                   main=" Estrogene Receptor 1 con SNPs in EnhancerOFF ",
                   sub=" Grado di alterazione degli SNPs fra cancro al seno e linea cellulare del cancro alla prostata ",
                   xlab=" Linea Cellulare ",
                   ylab=" ( ScoreAlt - ScoreRef ) / MaxScore",
                   col="brown",
                   border="red")
axis(side = 1,at = 1:2,labels=c("Cancro al Seno", "Cancro alla Prostata"),lwd.ticks = FALSE)
png(filename="Seno/Prostata_EnhancerON_ESR1.png")
plot(boxPlot)
dev.off()

