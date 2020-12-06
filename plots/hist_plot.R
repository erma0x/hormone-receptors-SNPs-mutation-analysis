###################################################################################### 
########################## GeneSymbolsID = 24 Androgene Receptor Gene
# 25
#         select SNPs_PFM.SNPID, (SNPs_PFM.scoreRef/SNPs_PFM.scoreALT) , SNPs.pos, SNPs_PFM.type
#         FROM ((SNPs_PFM INNER JOIN PFM ON (SNPs_PFM.PFMID=PFM.PFMID))
#         INNER JOIN SNPs ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE (SNPs_PFM.type IN (",lista_type,"))
#         AND SNPs_PFM.SNPID IN ( select SNPs_PFM.SNPID FROM SNPs_PFM LEFT JOIN PFM_GeneSymbols 
#         ON (SNPs_PFM.PFMID=PFM_GeneSymbols.PFMID) WHERE PFM_GeneSymbols.GENESYMBOLID==24)                
#         GROUP BY SNPs_PFM.SNPID,SNPs_PFM.type;
#


####################################################################################### 
" Instogrammi SOLO per Androgene Receptor, 
  sostituire PFM_GeneSymbols.GENESYMBOLID nella query per gli altri geni "

" SELECT  SNPs_PFM.SNPID, (SNPs_PFM.scoreRef/SNPs_PFM.scoreALT) , SNPs.pos, SNPs_PFM.type "

" per applicarla agli altri geni, basta cambiare nella query 25 del file query
 ' PFM_GeneSymbols.GENESYMBOLID==24 ' 
  con l' ID del gene di interesse "

file=ClearFromSpace(fileDirectory,'dati25.csv')
v<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

v1<-subset(v, SNPs_PFM.type=='match', select = c(SNPs.pos)) # freq delle posizioni SNPs
v2<-subset(v, SNPs_PFM.type=='change', select = c(SNPs.pos))  # divisi per tipologia
v3<-subset(v, SNPs_PFM.type=='addition', select = c(SNPs.pos))
v4<-subset(v, SNPs_PFM.type=='delition', select = c(SNPs.pos))

c1<-hist(v1,breaks = 10) # match
c2<-hist(v2,breaks = 10) # change
c3<-hist(v3,breaks = 10) # addition
c4<-hist(v4,breaks = 10) # delition

histogram_AR = cbind(c1,c2,c3,c4) # bind all together
Hist_AR = as.data.frame(histogram_AR) # transform into DataFrame
hist(Hist_AR) # plot 