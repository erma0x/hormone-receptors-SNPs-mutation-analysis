source(file ="./modules/lib.R")
librerie()
source(file ="./modules/funzioni.R")
source(file="./modules/funzioniPlot.R")
source(file ="./modules/var.R",local = T)
setwd(fileDirectory) # DA RISETTARE

hormon<-function(){ 
   "Prende tutte le combinazioni possibili dei Geni in studio: modificazioni istoniche, 
    tipo di modificazioni e tipo di file. Per ogni combinazione scrive un file csv,
    con dentro i dati di frequenza delle diverse ID degli SNP e delle corrispettive
    ID delle linee cellulari. Viene riportata ogni combinazione SNPID-CELLLINEID
    raggruppamento mediante: group by CELLLINEID, SNPID order SNPID"
   
   lista_geniID = c(24,401,402,1055,1056,1117)
   lista_fileType = c('broad', 'narrow')
   lista_functionalElement = c('(ElementID=475) and not (ElementID=477)','(ElementID=753)','(ElementID=755)')
   lista_type = c('match','change','addition','deletion')

   for (geniID in lista_geniID){
      for (fileType in lista_fileType){
         for(fe in lista_functionalElement){
            for (type in lista_type){
               q<-glue(paste("select count(SNPID),CELLLINEID from SNPs_FunctionalElement where
               SNPID in (select SNPID from SNPs_PFM where type='{type}' and PFMID in 
               (select PFMID from PFM_GeneSymbols where (GENESYMBOLID = {geniID}))) and ({fe})
               and (fileType = '{type}') group by CELLLINEID, SNPID order SNPID by asc;"))
               print(glue('File in Elaborazione  : {type}_{geniID}_{fe}_{fileType}'))
               write(q,paste(glue('{type}_{geniID}_{fe}_{fileType}',directory=FileDirectory)))}}}}} 
                                                            
               
               
hormon()



