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
# Hairless Receptor 
###############################################################################
Seno_EnhancerOFF_HR<-paste("select (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore)
                 FROM  (( SNPs_FunctionalElement INNTER JOIN SNPs
                 ON SNPs_FunctionalElement.SNPID=SNPs.SNPID)
                 INNER JOIN SNPs_PFM ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE
                 SNPs.SNPID IN (select SNPs_PFM.SNPID from SNPs_PFM LEFT JOIN
                 PFM_GeneSymbols ON (PFMID)
                 WHERE PFM_GeneSymbols_GENESYMBOLID=1056 and SNPs_PFM.type='match'
                 group by SNPs_PFM.SNPID )
                 AND SNPs_FunctionalElement.fileType='broad' AND ",SNP_FE[1],"
                 AND SNPs_FunctionalElement.CELLINEID=",IDcellLine_Cancro_al_SENO,"
                 GROUP BY SNPs.SNPID ORDER BY (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore) DESC;")
Save(DataBase = db,query = Seno_EnhancerOFF_HR,fileName = 'Seno_EnhancerOFF_HR.csv')

Seno_EnhancerON_HR<-paste("select (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore)
                 FROM  (( SNPs_FunctionalElement INNTER JOIN SNPs
                 ON SNPs_FunctionalElement.SNPID=SNPs.SNPID)
                 INNER JOIN SNPs_PFM ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE
                 SNPs.SNPID IN (select SNPs_PFM.SNPID from SNPs_PFM LEFT JOIN
                 PFM_GeneSymbols ON (PFMID)
                 WHERE PFM_GeneSymbols_GENESYMBOLID=1056 and SNPs_PFM.type='match'
                 group by SNPs_PFM.SNPID )
                 AND SNPs_FunctionalElement.fileType='broad' AND ",SNP_FE[2],"
                 AND SNPs_FunctionalElement.CELLINEID=",IDcellLine_Cancro_al_SENO,"
                 GROUP BY SNPs.SNPID ORDER BY (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore) DESC;")
Save(DataBase = db,query = Seno_EnhancerON_HR,fileName = 'Seno_EnhancerON_HR.csv')

Seno_Promoter_HR<-paste("select  (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore)
                 FROM  (( SNPs_FunctionalElement INNTER JOIN SNPs
                 ON SNPs_FunctionalElement.SNPID=SNPs.SNPID)
                 INNER JOIN SNPs_PFM ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE
                 SNPs.SNPID IN (select SNPs_PFM.SNPID from SNPs_PFM LEFT JOIN
                 PFM_GeneSymbols ON (PFMID)
                 WHERE PFM_GeneSymbols_GENESYMBOLID=1056 and SNPs_PFM.type='match'
                 group by SNPs_PFM.SNPID )
                 AND SNPs_FunctionalElement.fileType='broad' AND ",SNP_FE[3],"
                 AND SNPs_FunctionalElement.CELLINEID=",IDcellLine_Cancro_al_SENO,"
                 GROUP BY SNPs.SNPID ORDER BY (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore) DESC;")
Save(DataBase = db,query = Seno_Promoter_HR,fileName = 'Seno_Promoter_HR.csv')

## PROSTATA
Prostata_EnhancerOFF_HR<-paste("select   (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore)
                 FROM  (( SNPs_FunctionalElement INNTER JOIN SNPs
                 ON SNPs_FunctionalElement.SNPID=SNPs.SNPID)
                 INNER JOIN SNPs_PFM ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE
                 SNPs.SNPID IN (select SNPs_PFM.SNPID from SNPs_PFM LEFT JOIN
                 PFM_GeneSymbols ON (PFMID)
                 WHERE PFM_GeneSymbols_GENESYMBOLID=1056 and SNPs_PFM.type='match'
                 group by SNPs_PFM.SNPID )
                 AND SNPs_FunctionalElement.fileType='broad' AND ",SNP_FE[1],"
                 AND SNPs_FunctionalElement.CELLINEID=",IDcellLine_Cancro_alla_PROSTATA,"
                 GROUP BY SNPs.SNPID ORDER BY (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore) DESC;")
Save(DataBase = db,query = Prostata_EnhancerOFF_HR,fileName = 'Prostata_EnhancerOFF_HR.csv')

Prostata_EnhancerON_HR<-paste("select  (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore)
                 FROM  (( SNPs_FunctionalElement INNTER JOIN SNPs
                 ON SNPs_FunctionalElement.SNPID=SNPs.SNPID)
                 INNER JOIN SNPs_PFM ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE
                 SNPs.SNPID IN (select SNPs_PFM.SNPID from SNPs_PFM LEFT JOIN
                 PFM_GeneSymbols ON (PFMID)
                 WHERE PFM_GeneSymbols_GENESYMBOLID=1056 and SNPs_PFM.type='match'
                 group by SNPs_PFM.SNPID )
                 AND SNPs_FunctionalElement.fileType='broad' AND ",SNP_FE[2],"
                 AND SNPs_FunctionalElement.CELLINEID=",IDcellLine_Cancro_alla_PROSTATA,"
                 GROUP BY SNPs.SNPID ORDER BY (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore) DESC;")
Save(DataBase = db,query = Prostata_EnhancerON_HR,fileName = 'Prostata_EnhancerON_HR.csv')

Prostata_Promoter_HR<-paste("select (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore)
                 FROM  (( SNPs_FunctionalElement INNTER JOIN SNPs
                 ON SNPs_FunctionalElement.SNPID=SNPs.SNPID)
                 INNER JOIN SNPs_PFM ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE
                 SNPs.SNPID IN (select SNPs_PFM.SNPID from SNPs_PFM LEFT JOIN
                 PFM_GeneSymbols ON (PFMID)
                 WHERE PFM_GeneSymbols_GENESYMBOLID=1056 and SNPs_PFM.type='match'
                 group by SNPs_PFM.SNPID )
                 AND SNPs_FunctionalElement.fileType='broad' AND ",SNP_FE[3],"
                 AND SNPs_FunctionalElement.CELLINEID=",IDcellLine_Cancro_alla_PROSTATA,"
                 GROUP BY SNPs.SNPID ORDER BY (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore) DESC;")
Save(DataBase = db,query = Prostata_Promoter_HR,fileName = 'Prostata_Promoter_HR.csv')


########## BOX PLOT ENHANCER OFF GR  ################

file=ClearFromSpace(fileDirectory,'Seno_EnhancerOFF_HR.csv')
Seno_EnhancerOFF_HR<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

file=ClearFromSpace(fileDirectory,'Prostata_EnhancerOFF_HR.csv')
Prostata_EnhancerOFF_HR<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

boxPlot <- boxplot(Seno_EnhancerOFF_HR,
                   Prostata_EnhancerOFF_HR,notch = TRUE,xticks=c('a','b'),
                   main=" Hairless Receptor con SNPs in EnhancerOFF ",
                   sub=" Grado di alterazione degli SNPs fra cancro al seno e linea cellulare del cancro alla prostata ",
                   xlab=" Linea Cellulare ",
                   ylab=" ( ScoreAlt - ScoreRef ) / MaxScore",
                   col="orange",
                   border="blue")
axis(side = 1,at = 1:2,labels=c("Cancro al Seno", "Cancro alla Prostata"),lwd.ticks = FALSE)
png(filename="Seno/Prostata_EnhancerOFF_HR.png")
plot(boxPlot)

########## BOX PLOT ENHANCER ON  ################

file=ClearFromSpace(fileDirectory,'Seno_EnhancerON_HR.csv')
Seno_EnhancerON_HR<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

file=ClearFromSpace(fileDirectory,'Prostata_EnhancerON_HR.csv')
Prostata_EnhancerON_HR<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

boxPlot <- boxplot(Seno_EnhancerON_HR,
                   Prostata_EnhancerON_HR,notch = TRUE,
                   main=" Hairless Receptor con SNPs in EnhancerON ",
                   sub=" Grado di alterazione degli SNPs fra cancro al seno e linea cellulare del cancro alla prostata ",
                   xlab=" Linea Cellulare ",
                   ylab=" ( ScoreAlt - ScoreRef ) / MaxScore",
                   col="black",
                   border="yellow")
axis(side = 1,at = 1:2,labels=c("Cancro al Seno", "Cancro alla Prostata"),lwd.ticks = FALSE)
png(filename="Seno/Prostata_EnhancerON_HR.png")
plot(boxPlot)
dev.off()

########## BOX PLOT PROMOTER  ################
file=ClearFromSpace(fileDirectory,'Seno_EnhancerOFF_HR.csv')
Seno_EnhancerOFF_HR<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

file=ClearFromSpace(fileDirectory,'Prostata_EnhancerOFF_HR.csv')
Prostata_EnhancerOFF_HR<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

boxPlot <- boxplot(Seno_EnhancerOFF_HR,
                   Prostata_EnhancerOFF_HR,notch = TRUE,
                   main=" Hairless Receptor con SNPs in EnhancerOFF ",
                   sub=" Grado di alterazione degli SNPs fra cancro al seno e linea cellulare del cancro alla prostata ",
                   xlab=" Linea Cellulare ",
                   ylab=" ( ScoreAlt - ScoreRef ) / MaxScore",
                   col="brown",
                   border="red")
axis(side = 1,at = 1:2,labels=c("Cancro al Seno", "Cancro alla Prostata"),lwd.ticks = FALSE)
png(filename="Seno/Prostata_EnhancerON_HR.png")
plot(boxPlot)
dev.off()
