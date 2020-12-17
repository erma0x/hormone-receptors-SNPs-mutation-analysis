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
# Progesterone Receptor
###############################################################################
Seno_EnhancerOFF_PGR<-paste("select (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore)
                 FROM  (( SNPs_FunctionalElement INNTER JOIN SNPs
                 ON SNPs_FunctionalElement.SNPID=SNPs.SNPID)
                 INNER JOIN SNPs_PFM ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE
                 SNPs.SNPID IN (select SNPs_PFM.SNPID from SNPs_PFM LEFT JOIN
                 PFM_GeneSymbols ON (PFMID)
                 WHERE PFM_GeneSymbols_GENESYMBOLID=1055 and SNPs_PFM.type='match'
                 group by SNPs_PFM.SNPID )
                 AND SNPs_FunctionalElement.fileType='broad' AND ",SNP_FE[1],"
                 AND SNPs_FunctionalElement.CELLINEID=",IDcellLine_Cancro_al_SENO,"
                 GROUP BY SNPs.SNPID ORDER BY (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore) DESC;")
Save(DataBase = db,query = Seno_EnhancerOFF_PGR,fileName = 'Seno_EnhancerOFF_PGR.csv')

Seno_EnhancerON_PGR<-paste("select (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore)
                 FROM  (( SNPs_FunctionalElement INNTER JOIN SNPs
                 ON SNPs_FunctionalElement.SNPID=SNPs.SNPID)
                 INNER JOIN SNPs_PFM ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE
                 SNPs.SNPID IN (select SNPs_PFM.SNPID from SNPs_PFM LEFT JOIN
                 PFM_GeneSymbols ON (PFMID)
                 WHERE PFM_GeneSymbols_GENESYMBOLID=1055 and SNPs_PFM.type='match'
                 group by SNPs_PFM.SNPID )
                 AND SNPs_FunctionalElement.fileType='broad' AND ",SNP_FE[2],"
                 AND SNPs_FunctionalElement.CELLINEID=",IDcellLine_Cancro_al_SENO,"
                 GROUP BY SNPs.SNPID ORDER BY (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore) DESC;")
Save(DataBase = db,query = Seno_EnhancerON_PGR,fileName = 'Seno_EnhancerON_PGR.csv')

Seno_Promoter_PGR<-paste("select  (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore)
                 FROM  (( SNPs_FunctionalElement INNTER JOIN SNPs
                 ON SNPs_FunctionalElement.SNPID=SNPs.SNPID)
                 INNER JOIN SNPs_PFM ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE
                 SNPs.SNPID IN (select SNPs_PFM.SNPID from SNPs_PFM LEFT JOIN
                 PFM_GeneSymbols ON (PFMID)
                 WHERE PFM_GeneSymbols_GENESYMBOLID=1055 and SNPs_PFM.type='match'
                 group by SNPs_PFM.SNPID )
                 AND SNPs_FunctionalElement.fileType='broad' AND ",SNP_FE[3],"
                 AND SNPs_FunctionalElement.CELLINEID=",IDcellLine_Cancro_al_SENO,"
                 GROUP BY SNPs.SNPID ORDER BY (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore) DESC;")
Save(DataBase = db,query = Seno_Promoter_PGR,fileName = 'Seno_Promoter_PGR.csv')

## PROSTATA
Prostata_EnhancerOFF_PGR<-paste("select   (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore)
                 FROM  (( SNPs_FunctionalElement INNTER JOIN SNPs
                 ON SNPs_FunctionalElement.SNPID=SNPs.SNPID)
                 INNER JOIN SNPs_PFM ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE
                 SNPs.SNPID IN (select SNPs_PFM.SNPID from SNPs_PFM LEFT JOIN
                 PFM_GeneSymbols ON (PFMID)
                 WHERE PFM_GeneSymbols_GENESYMBOLID=1055 and SNPs_PFM.type='match'
                 group by SNPs_PFM.SNPID )
                 AND SNPs_FunctionalElement.fileType='broad' AND ",SNP_FE[1],"
                 AND SNPs_FunctionalElement.CELLINEID=",IDcellLine_Cancro_alla_PROSTATA,"
                 GROUP BY SNPs.SNPID ORDER BY (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore) DESC;")
Save(DataBase = db,query = Prostata_EnhancerOFF_PGR,fileName = 'Prostata_EnhancerOFF_PGR.csv')

Prostata_EnhancerON_PGR<-paste("select  (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore)
                 FROM  (( SNPs_FunctionalElement INNTER JOIN SNPs
                 ON SNPs_FunctionalElement.SNPID=SNPs.SNPID)
                 INNER JOIN SNPs_PFM ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE
                 SNPs.SNPID IN (select SNPs_PFM.SNPID from SNPs_PFM LEFT JOIN
                 PFM_GeneSymbols ON (PFMID)
                 WHERE PFM_GeneSymbols_GENESYMBOLID=1055 and SNPs_PFM.type='match'
                 group by SNPs_PFM.SNPID )
                 AND SNPs_FunctionalElement.fileType='broad' AND ",SNP_FE[2],"
                 AND SNPs_FunctionalElement.CELLINEID=",IDcellLine_Cancro_alla_PROSTATA,"
                 GROUP BY SNPs.SNPID ORDER BY (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore) DESC;")
Save(DataBase = db,query = Prostata_EnhancerON_PGR,fileName = 'Prostata_EnhancerON_PGR.csv')

Prostata_Promoter_PGR<-paste("select (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore)
                 FROM  (( SNPs_FunctionalElement INNTER JOIN SNPs
                 ON SNPs_FunctionalElement.SNPID=SNPs.SNPID)
                 INNER JOIN SNPs_PFM ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE
                 SNPs.SNPID IN (select SNPs_PFM.SNPID from SNPs_PFM LEFT JOIN
                 PFM_GeneSymbols ON (PFMID)
                 WHERE PFM_GeneSymbols_GENESYMBOLID=1055 and SNPs_PFM.type='match'
                 group by SNPs_PFM.SNPID )
                 AND SNPs_FunctionalElement.fileType='broad' AND ",SNP_FE[3],"
                 AND SNPs_FunctionalElement.CELLINEID=",IDcellLine_Cancro_alla_PROSTATA,"
                 GROUP BY SNPs.SNPID ORDER BY (SNPs.scoreALT-SNPs.scoreRef/SNPs.MaxScore) DESC;")
Save(DataBase = db,query = Prostata_Promoter_PGR,fileName = 'Prostata_Promoter_PGR.csv')


########## BOX PLOT ENHANCER OFF GR  ################

file=ClearFromSpace(fileDirectory,'Seno_EnhancerOFF_PGR.csv')
Seno_EnhancerOFF_PGR<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

file=ClearFromSpace(fileDirectory,'Prostata_EnhancerOFF_PGR.csv')
Prostata_EnhancerOFF_PGR<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

boxPlot <- boxplot(Seno_EnhancerOFF_PGR,
                   Prostata_EnhancerOFF_PGR,notch = TRUE,xticks=c('a','b'),
                   main=" Progesterone Receptor con SNPs in EnhancerOFF ",
                   sub=" Grado di alterazione degli SNPs fra cancro al seno e linea cellulare del cancro alla prostata ",
                   xlab=" Linea Cellulare ",
                   ylab=" ( ScoreAlt - ScoreRef ) / MaxScore",
                   col="orange",
                   border="blue")
axis(side = 1,at = 1:2,labels=c("Cancro al Seno", "Cancro alla Prostata"),lwd.ticks = FALSE)
png(filename="Seno/Prostata_EnhancerOFF_PGR.png")
plot(boxPlot)

########## BOX PLOT ENHANCER ON  ################

file=ClearFromSpace(fileDirectory,'Seno_EnhancerON_PGR.csv')
Seno_EnhancerON_PGR<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

file=ClearFromSpace(fileDirectory,'Prostata_EnhancerON_PGR.csv')
Prostata_EnhancerON_PGR<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

boxPlot <- boxplot(Seno_EnhancerON_PGR,
                   Prostata_EnhancerON_PGR,notch = TRUE,
                   main=" Progesterone Receptor  con SNPs in EnhancerON ",
                   sub=" Grado di alterazione degli SNPs fra cancro al seno e linea cellulare del cancro alla prostata ",
                   xlab=" Linea Cellulare ",
                   ylab=" ( ScoreAlt - ScoreRef ) / MaxScore",
                   col="black",
                   border="yellow")
axis(side = 1,at = 1:2,labels=c("Cancro al Seno", "Cancro alla Prostata"),lwd.ticks = FALSE)
png(filename="Seno/Prostata_EnhancerON_PGR.png")
plot(boxPlot)
dev.off()

########## BOX PLOT PROMOTER  ################
file=ClearFromSpace(fileDirectory,'Seno_EnhancerOFF_PGR.csv')
Seno_EnhancerOFF_PGR<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

file=ClearFromSpace(fileDirectory,'Prostata_EnhancerOFF_PGR.csv')
Prostata_EnhancerOFF_PGR<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

boxPlot <- boxplot(Seno_EnhancerOFF_PGR,
                   Prostata_EnhancerOFF_PGR,notch = TRUE,
                   main=" Progesterone Receptor con SNPs in EnhancerOFF ",
                   sub=" Grado di alterazione degli SNPs fra cancro al seno e linea cellulare del cancro alla prostata ",
                   xlab=" Linea Cellulare ",
                   ylab=" ( ScoreAlt - ScoreRef ) / MaxScore",
                   col="brown",
                   border="red")
axis(side = 1,at = 1:2,labels=c("Cancro al Seno", "Cancro alla Prostata"),lwd.ticks = FALSE)
png(filename="Seno/Prostata_EnhancerON_PGR.png")
plot(boxPlot)
dev.off()
