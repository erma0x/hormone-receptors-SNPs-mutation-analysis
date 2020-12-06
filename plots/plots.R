library(ggplot2) 
theme_set(theme_bw())

source(file ="./modules/lib.R")
librerie()
source(file ="./modules/funzioni.R")
source(file="./modules/funzioniPlot.R")
source(file ="./modules/var.R",local = T)
setwd(fileDirectory) # DA RISETTARE

"
ESEMPIO design di un blocco di Barplot
"
####################################################################################### 
# Breve descrizione della query

# Numero query del file query.R

# query in SQL dal file query.R

# spiegazione di cosa fa la query
##################################################################################
# CODICE R PER IL BARPLOT
#file=c(directory)
#v<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)
#barplot(v$count.distinct.SNPs_FunctionalElement.SNPID.,width = 0.95,col=c("#3CA0D0"),
#             xlab = 'Histon Mod',ylab='Distinct SNP')
#text(seq(v$name), par("name"), labels = v$name, srt = 45, pos = 1, xpd = TRUE)
####################################################################################### 


# INIZIO SCRIPT plots.R
####################################################################################### 
############### distinctSNP in HISTON MOD PLOT
file=ClearFromSpace(fileDirectory,'Count_distinct_SNP_histon_modification_type.txt')
v<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)
barplot(v$count.distinct.SNPs_FunctionalElement.SNPID.,width = 0.95,col=c("#3CA0D0"), xlab = 'Histon Mod',ylab='Distinct SNP')
text(seq(v$name), par("name"), labels = v$name, srt = 45, pos = 1, xpd = TRUE)
####################################################################################### 

####################################################################################### 
###############  Freq SNP per ogni SNP
# 7
#     select SNPs_PFM.SNPID, count(SNPs_PFM.SNPID) FROM SNPs_PFM 
#     INNER JOIN PFM ON (SNPs_PFM.PFMID=PFM.PFMID) 
#     WHERE (SNPs_PFM.type = 'match') GROUP BY SNPs_PFM.SNPID;

#    conta la frequenza di SNPs delle PFM per ogni SNPID
file=ClearFromSpace(fileDirectory,'dati7.csv')
v<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)
barplot(v$count.SNPs_PFM.SNPID.,width = 0.95,col=c("#3CA0D0"), xlab = 'SNP ID',ylab='Freq SNP')
text(seq(v$SNPs_PFM.SNPID), par("SNPs_PFM.SNPID"), labels = v$SNPs_PFM.SNPID, srt = 45, pos = 1, xpd = TRUE)
####################################################################################### 


####################################################################################### 
###############  Conta Frequenza Elementi Funzionali in tutto il DB
# 8
#               select ElementID, count(distinct SNPID), count(ElementID), count(distinct CELLLINEID) 
#               from SNPs_FunctionalElement group by ElementID order by count(SNPID) desc;")

# conta il numero di diversi SNP e linee cellulari per ogni Elemento Funzionale
file=ClearFromSpace(fileDirectory,'dati8.csv')
v<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)
barplot(v$count.ElementID.,width = 0.95,col=c("#3CA0D0"), xlab = 'ElementID',ylab='Frequenza Elemento ')
text(seq(v$count.ElementID.), par("count(ElementID)"), labels = v$ElementID., srt = 45, pos = 1, xpd = TRUE)
############## Conta Elementi Funzionali associati a piu' SNP Diversi
barplot(v$count.distinct.SNPID.,width = 0.95,col=c("#3CA0D0"), xlab = 'ElementID',ylab='Num SNP diversi ')
text(seq(v$count.distinct.SNPID.), par("count(distinct SNPID)"), labels = v$ElementID., srt = 45, pos = 1, xpd = TRUE)
############## Conta numero di Celline diverse associate per ogni Elemento funzionale
barplot(v$count.distinct.CELLLINEID.,width = 0.95,col=c("#3CA0D0"), xlab = 'ElementID',ylab='Num Line Cellulari diverse ')
text(seq(v$count.distinct.CELLLINEID.), par("count(distinct CELLLINEID)"), labels = v$ElementID., srt = 45, pos = 1, xpd = TRUE)
####################################################################################### 


####################################################################################### 
############## SNPID/ AVG(Ref/Alt)
# 9        
#            
#               select SNPs_PFM.SNPID, AVG(SNPs_PFM.scoreRef/SNPs_PFM.scoreALT) FROM SNPs_PFM 
#               INNER JOIN PFM ON (SNPs_PFM.PFMID=PFM.PFMID) WHERE (SNPs_PFM.type = 'match')
#               GROUP BY SNPs_PFM.SNPID ORDER BY AVG(SNPs_PFM.scoreRef/SNPs_PFM.scoreALT) DESC;

# Per ogni SNP ID calcola la media delle modifiche che quello SNP comporta
# calcolando il rapporto fra Score di Riferimento e Score Alternativo
file=ClearFromSpace(fileDirectory,'dati9.csv')
v<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)
barplot(v$count.ElementID.,width = 0.95,col=c("#3CA0D0"), xlab = 'ElementID',ylab='Frequenza Elemento ')
text(seq(v$count.ElementID.), par("count(ElementID)"), labels = v$ElementID., srt = 45, pos = 1, xpd = TRUE)
####################################################################################### 



####################################################################################### 
############## count distinct SNP / PFMID
# 10
#       select count(distinct SNPs_PFM.SNPID),PFM.PFMID,PFM.name from SNPs_PFM,
#       PFM WHERE (SNPs_PFM.PFMID=PFM.PFMID) AND (SNPs_PFM.type = 'match')
#       GROUP BY PFM.PFMID;") #ORDER BY count(distinct SNPs_PFM.SNPID) DESC

# Conta il numero dei diversi SNP in ogni PFM 
file=ClearFromSpace(fileDirectory,'dati10.csv')
v<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)
barplot(v$count.distinct.SNPs_FunctionalElement.SNPID.,width = 0.95,col=c("#3CA0D0"), xlab = 'PFM.PFMID',ylab='Frequenza Elemento ')
text(seq(v$count.distinct.SNPs_FunctionalElement.SNPID.), par("count.distinct.SNPs_FunctionalElement.SNPID."), labels = v$PFM.PFMID, srt = 45, pos = 1, xpd = TRUE)
####################################################################################### 





####################################################################################### 
############## count SNP MATCH / PFMID    (maf not NULL)
# 11
#       select count(SNPs_PFM.SNPID),count(distinct SNPs_PFM.SNPID),PFM.PFMID
#       from (( SNPs_PFM INNER JOIN PFM ON (SNPs_PFM.PFMID=PFM.PFMID)) INNER JOIN
#       SNPs ON (SNPs_PFM.SNPID=SNPs.SNPID))
#       WHERE (SNPs_PFM.type = 'match') AND (SNPs.mafTOPMed IS NOT NULL) AND
#       (SNPs.maf1000genomes IS NOT NULL)
#       GROUP BY PFM.PFMID ORDER BY count(distinct SNPs_PFM.SNPID) DESC;")

# Per ogni PFM riporta la somma degli SNP in match con valori MAF non nulla 
file=ClearFromSpace(fileDirectory,'dati11.csv')
v<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)
# conta il numero di SNP in frequenza, ed il numero dei diversi SNPs presente in ogni PFM
# dove il Dato non e'Nullo
barplot(v$count.SNPs_PFM.SNPID.,width = 0.95,col=c("#3CA0D0"),
        xlab = 'PFMID',ylab='Numero SNPs totali ')
text(seq(v$count.SNPs_PFM.SNPID.),
     par("PFMID"), labels = v$PFM.PFMID, srt = 45, pos = 1, xpd = TRUE)
############## count distinct SNP MATCH / PFMID
barplot(v$count.distinct.SNPs_FunctionalElement.SNPID.,width = 0.95,col=c("#3CA0D0"),
        xlab = 'PFMID',ylab='Numero SNPs diversi ')
text(seq(v$count.distinct.SNPs_FunctionalElement.SNPID.),
     par("PFMID"), labels = v$PFM.PFMID, srt = 45, pos = 1, xpd = TRUE)
####################################################################################### 




####################################################################################### 
##############  freqSNPs/SNPID  
# 12 
#             select count(SNPs_PFM.SNPID), AVG(SNPs_PFM.scoreRef/SNPs_PFM.scoreALT)
#             FROM SNPs_PFM,PFM WHERE (SNPs_PFM.PFMID=PFM.PFMID) AND SNPs_PFM.fileType='broad'
#             AND (SNPs_PFM.type = 'match') GROUP BY SNPs_PFM.SNPID;

# per ogni SNPID riporta la frequenza, la media fra ScoreRef ed Alt che quello SNP porta
# file di tipo match and broad
# frequenza di ogni SNPs per ogni SNPs

file=ClearFromSpace(fileDirectory,'dati12.csv')
v<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE) 

##############  AVG(SNPs...)/SNPID
barplot(v$AVG.SNPs_PFM.scoreRef.SNPs_PFM.scoreALT.,width = 0.95,col=c("#3CA0D0"),
        xlab = 'SNPID',ylab='Score Ref / Alt  ')
text(seq(v$AVG.SNPs_PFM.scoreRef.SNPs_PFM.scoreALT.),
     par("SNPID"), labels = v$SNPs_PFM.SNPID, srt = 45, pos = 1, xpd = TRUE)
####################################################################################### 




####################################################################################### 
#################### count distinct SNP / CHR
# 14
# Conta numero SNP diversi per Chr

#     select count(distinct SNPs_FunctionalElement.SNPID)
#     SNPs.chrom from SNPs_FunctionalElement
#     INNER JOIN SNPs USING (SNPID) group by SNPs.chrom;") 

# Conta il numero di tutti gli Elementi Funzionali per Chr
file=ClearFromSpace(fileDirectory,'dati14.csv')
v<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

barplot(v$count.distinct.SNPs_FunctionalElement.SNPID.,width = 0.95,col=c("#3CA0D0"),
        xlab = 'num Chr',ylab='Distinct SNP')
text(seq(v$SNPs.chrom), par("SNPs.chrom"), labels = v$SNPs.chrom, srt = 45, pos = 1, xpd = TRUE)
####################################################################################### 


####################################################################################### 
#################### count Element / CHR
# 14_1
#     select count(SNPs_FunctionalElement.ElementID),
#     SNPs.chrom from SNPs_FunctionalElement
#     INNER JOIN SNPs USING (SNPID) group by SNPs.chrom;") 

file=ClearFromSpace(fileDirectory,'dati14_1.csv')
v<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)
barplot(v$count.SNPs_FunctionalElement.ElementID.,width = 0.95,col=c("#3CA0D0"),
        xlab = 'num Chr',ylab=' Num Element ')
text(seq(v$SNPs.chrom), par("SNPs.chrom"), labels = v$SNPs.chrom, srt = 45, pos = 1, xpd = TRUE)
####################################################################################### 




####################################################################################### 
####################  count SNP/ ElementID
# 15 
#         select count(SNPs_FunctionalElement.SNPID), SNPs_FunctionalElement.ElementID, 
#         count(SNPs_FunctionalElement.CELLLINEID) from SNPs_FunctionalElement
#         INNER JOIN SNPs USING (SNPID) group by SNPs_FunctionalElement.ElementID;")

# Conta il numero degli SNP che sono associati, ognuno con un elemento funzionale diverso 
file=ClearFromSpace(fileDirectory,'dati15.csv')
v<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

barplot(v$count.SNPs_FunctionalElement.SNPID.,width = 0.95,col=c("#3CA0D0"),
        xlab = 'Element ID',ylab=' Num SNPs ')
text(seq(v$SNPs_FunctionalElement.ElementID), par("SNPs_FunctionalElement.ElementID"), labels = v$SNPs_FunctionalElement.ElementID, srt = 45, pos = 1, xpd = TRUE)

################### count CellLineID / ElementID
barplot(v$count.SNPs_FunctionalElement.CELLLINEID.,width = 0.95,col=c("#3CA0D0"),
        xlab = 'Element ID',ylab=' Num CellLine ')
text(seq(v$SNPs_FunctionalElement.ElementID), par("SNPs_FunctionalElement.ElementID"), labels = v$SNPs_FunctionalElement.ElementID, srt = 45, pos = 1, xpd = TRUE)
####################################################################################### 



####################################################################################### 
####################  freqElementID / ElementID
# 16
#       select ElementID, count(ElementID), 
#       from SNPs_FunctionalElement WHERE fileType='broad' group by ElementID;")

# Conta le frequenze di ogni elemento ed il numero degli SNP diversi che sono associati,
# ognuno con un elemento funzionale diverso 
file=ClearFromSpace(fileDirectory,'dati16.csv')
v<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)
barplot(v$count.ElementID.,width = 0.95,col=c("#3CA0D0"),
        xlab = 'Element ID',ylab=' Frequenza ')
text(seq(v$ElementID), par("ElementID"), labels = v$ElementID, srt = 45, pos = 1, xpd = TRUE)
####################################################################################### 


####################################################################################### 
#################### Tutti gli SNPs in broad di Androgen Receptor con Nucleotide di Riferimento Citosina
# 17                          e come tipo di nucleotide un Match                

#                select count(SNPs_FunctionalElement.SNPID), SNPs_FunctionalElement.ElementID,
#                count(SNPs_FunctionalElement.CELLLINEID) from SNPs_FunctionalElement 
#                INNER JOIN SNPs USING (SNPID) WHERE SNPs_FunctionalElement.countExperiments>2 AND
#                SNPs_FunctionalElement.fileType='broad' AND SNPs_FunctionalElement.ElementID IN (",SNP_FE,")
#                SNPs.SNPID IN (select SNPs_PFM.SNPID from SNPs_PFM LEFT JOIN PFM_GeneSymbols ON (PFMID) 
#                WHERE PFM_GeneSymbols_GENESYMBOLID=24 and SNPs_PFM.type='match' group by SNPs_PFM.SNPID )
#                group by SNPs_FunctionalElement.ElementID,SNPs_FunctionalElement.CELLLINEID;

#  GENE: AR | file Type: broad | SNPs type: MATCH | Element: promoter, enhancerON, enhancerOFF | CellLine: cellLines_di_interesse

# Le combinazioni sono: 5(geni)*2(fileType)*4(SNPsRef)*4(SNPstype)*3(FunctionalElement[promoter,enhancerON,enhancerOFF])
# MOSTRO SOLO UNA COMBINAZIONE
# Per estrarre tutte le combinazioni, o creo un unico DataSet (enorme), o creo tanti csv differenziati per le 
# diverse combinazioni di elementi della query

file=ClearFromSpace(fileDirectory,'dati17.csv')
v<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)
count <- table(v$count.SNPs_FunctionalElement.SNPID., v$SNPs_FunctionalElement.CELLLINEID)
barplot(count , width = 0.95,col=c("rosybrown2", "seagreen", "royalblue"),
        xlab = 'Element ID',ylab=' Frequenza ',main = 'Androgene Receptor',
        sub = 'GENE: AR | file Type: broad | SNPs type: MATCH | Element: promoter, enhancerON, enhancerOFF | CellLine: cellLines_di_interesse')
####################################################################################### 




####################################################################################### 
##########################  Seleziona tutti gli SNPs appartenenti ai geni di interesse, e riporta il numero totale 
#  18                          di SNPs diversi per ciascuno, ed il numero di elementi legati ad esso,
#                               raggruppati per CellLineID (dove prendo le cellLine di interesse)
#                                 
# 
#       select count(distinct SFE.SNPID), count(distinct SFE.ElementID), 
#       SFE from SNPs_FunctionalElement as SFE WHERE 
#       SFE.CELLLINEID IN (IDlinee_cellulari_di_interesse)
#       INNER JOIN SNPs USING (SNPID) group by SFE.CELLLINEID ;

file=ClearFromSpace(fileDirectory,'dati18.csv')
v<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)
altezza <- v$count.distinct.SFE.SNPID. # 4nt x numero_GeniID # ex 25 bar
nomeGeni <- c('AR','ESR1', 'ESR2', 'GR', 'HR', 'PGR')
png(file = "barchart_months_revenue.png") # Give the chart file a name
barplot(H,names.arg=nomeGeni,xlab="Nome Geni",ylab="Conta dei diversi SNPs associati",col="blue",main="distinct SNPs per Gene",border="red")
# Save the file
dev.off()
####################################################################################### 





####################################################################################### 
##########################  come la numero 18, ma con ulteriore Group by ai SNPs di riferimento
#  18_1                         quindi ogni lineaCellulare avra' 4 differenti conte di SNPs
#                                   associate ai 4 Nucleotidi di partenza (A,C,T,G)
#
#       select count(distinct SFE.SNPID), count(distinct SFE.ElementID), 
#       SFE from SNPs_FunctionalElement as SFE WHERE 
#       SFE.CELLLINEID IN (IDlinee_cellulari_di_interesse)
#       INNER JOIN SNPs USING (SNPID) group by SFE.CELLLINEID , SNPs.ref ;

file=ClearFromSpace(fileDirectory,'dati18_1.csv')
v<-read.csv(file, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

colors = c("green","orange","brown","purple") # colors

nomeGeni <- c('AR','ESR1', 'ESR2', 'GR', 'HR', 'PGR') # genes
nucleotide <- c("A","C","G","T") # NT #### IMPORTANTE, Non sono convinto dell' ordine di restituzione 

# della conta della QUERY, potrebbe essere C,T,G,A
Values <- matrix(v, nrow = 4, ncol = 6, byrow = TRUE) # row = NT, ncol = Geni

png(file = "barchart_stacked.png") # save

barplot(Values, main = "total differents SNPs", names.arg = nomeGeni, xlab = "Gene Name ", ylab = "count distinct SNPs", col = colors)
legend("topleft", regions, cex = 1.3, fill = colors) 
dev.off() # Save the file
####################################################################################### 

# Le altre query dalla 18_1 alla 30_4 sono combinazioni di query semplici.
# Non sono funzionali per questo avviso di dargli un occhiata veloce.
# Ritengo che diano risultati simili alle prime query, quindi inutili quasi.






# multiple Histogram #############################################
"
 Plot dei diversi instogrammi per AR, 
 rappresentanti la frequenza di SNPs lungo il gene di interesse 
 divisi per tipologia di SNPs. Prendendo tutte le linee cellulari

"
#############################################
histMatch<-hist(v1$SNPs.pos, 
     main="Histogram for SNPs frequencies in AR type Match",
     xlab="SNPs positions along Chromosome", border="orange", col="gray",breaks=5)
histMatch
#############################################
histChange<-hist(v2$SNPs.pos, 
     main="Histogram for SNPs frequencies in AR type Change",
     xlab="SNPs positions along Chromosome", border="blue", col="green",breaks=5)
histChange
#############################################
histAddition-hist(v3$SNPs.pos, 
     main="Histogram for SNPs frequencies in AR type Addition",
     xlab="SNPs positions along Chromosome", border="red", col="green",breaks=5)
histAddition
#############################################
histDelition<-hist(v4$SNPs.pos, 
     main="Histogram for SNPs frequenciesin AR type Delition",
     xlab="SNPs positions along Chromosome", border="blue", col="red",breaks=5)
histDelition
#############################################

histChange
histAddition
histDelition


#########################
# PIE CHART FUNCTION FOR PLOTTING ALL THE GENES's SNPs type 

# lista_geniID = c(24,401,402,1055,1056,1117) # AR, ESR1, ESR2, GR, HR, PGR
PieChartFunction('dati26_AR.csv','pie_chart_AR.png','Androgene Receptor') # AR androgene receptor

PieChartFunction('dati26_ESR1.csv','pie_chart_ESR1.png','Estrogene Receptor 1') # ESR1 Estrogene Receptor alpha

PieChartFunction('dati26_ESR2.csv','pie_chart_ESR2.png','Estrogene Receptor 2') # ESR2 Estrogene Receptor beta

PieChartFunction('dati26_GR.csv','pie_chart_GR.png','Androgene Receptor') # GR glucocorticoid receptor

PieChartFunction('dati26_HR.csv','pie_chart_HR.png','Hairless Gene') # HR Hairless Lysine Demethylase And Nuclear Receptor Corepressor

PieChartFunction('dati26_PGR.csv','pie_chart_PGR.png','Progesterone Receptor') # PGR progesterone receptor
######################################################################################################
# Funzione per salvare le immagini
png(filename="NomeFigura_da_salvare.png")
dev.off()


