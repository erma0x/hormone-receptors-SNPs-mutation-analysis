#     BASH for connect to DB
#  $> sudo service mysql start
#  $> mysql -u root snpImpactResource -A
source(file ="./modules/lib.R")
librerie()
source(file ="./modules/funzioni.R")
source(file="./modules/funzioniPlot.R")
source(file ="./modules/var.R",local = T)
setwd(fileDirectory) # DA RISETTARE


# INIZIO QUERY ##########################################################
"
Spiegazioni query-design

 vanno in ordine di complessita'

 sono radunate per numeri ex. query_1

 possono esserci dei sotto-blocchi di query

 esempio   query_1_0, query_1_1, query_1_2

 Sotto ogni query c'e' una veloce descrizione

 Viene utilizzata solo la funzione Save
 A causa di errori di Overflow, disconnessioni al DB
 o errori in generale, puo' essere usata la funzione
 bigData() per gestire 4000 risultati alla volta
"
########################### 0
query_0 <- paste("select CELLLINEID, count(SNPID) 
                  from SNPs_FunctionalElement 
                  group by ElementID;")
dati_cellline_0 <- dbGetQuery(db, query_0) # Conta SNPs per CellLine

########################### 1
query_1 <- paste("select count(distinct SNPID) from SNPs limit 1;")
dati_1 <- dbGetQuery(db, query_1) 
#conta numero totale dei diversi SNPs = 14810175
 
########################### 2
query_2 <- paste("select count(distinct ElementID) from FunctionalElement limit 1;")
dati_2 <- dbGetQuery(db, query_2) 
#conta numero totale dei diversi Elementi Funzionali = 759

########################### 3
query_3 <- paste("select count(distinct CELLLINEID) from FunctionalElement limit 1;")
dati_3 <- dbGetQuery(db, query_3) 
#conta numero totale dei diversi CellLines = 238
 
########################### 4
query_4 <- paste("select count(distinct PFMID) FROM PFM;")
dati_4 <- dbGetQuery(db, query_4) 
#conta numero totale dei diversi PFM = 5424

########################### 5
query_5 <- paste("select count(distinct PFMID) FROM SNPs_PFM;")
dati_5 <- dbGetQuery(db, query_5) 
#conta numero totale dei diversi SNPs_PFM = 5352

########################### 6 
query_6<-paste("select PFM.PFMID,count(distinct SNPs_PFM.SNPID),
PFM.PFMID FROM SNPs_PFM 
INNER JOIN PFM ON (SNPs_PFM.PFMID=PFM.PFMID) 
WHERE (SNPs_PFM.type = 'match') GROUP BY PFM.PFMID;")
Save(DataBase = db,query = query_6, fileName = 'dati6.csv' )
# Conta il numero di SNPs diversi dentro ogni PFM di tipo 'match'

########################### 7
query_7<-paste("select SNPs_PFM.SNPID, count(SNPs_PFM.SNPID) FROM SNPs_PFM 
INNER JOIN PFM ON (SNPs_PFM.PFMID=PFM.PFMID) 
WHERE (SNPs_PFM.type = 'match') GROUP BY SNPs_PFM.SNPID ORDER BY count(SNPs_PFM.SNPID) DESC;")
# conta la frequenza di SNPs delle PFM per ogni SNPID
Save(DataBase = db,query = query_7, fileName = 'dati7.csv')

########################### 8
query_8<-paste("select ElementID, count(distinct SNPID), count(ElementID), count(distinct CELLLINEID) 
               from SNPs_FunctionalElement group by ElementID order by count(SNPID) desc;")
# conta il numero di diversi SNP e linee cellulari per ogni Elemento Funzionale
Save(DataBase = db,query = query_8,fileName = 'dati8.csv')

########################### 9
query_9<-paste("select SNPs_PFM.SNPID, AVG(SNPs_PFM.scoreRef/SNPs_PFM.scoreALT) FROM SNPs_PFM 
               INNER JOIN PFM ON (SNPs_PFM.PFMID=PFM.PFMID) WHERE (SNPs_PFM.type = 'match')
               GROUP BY SNPs_PFM.SNPID ORDER BY AVG(SNPs_PFM.scoreRef/SNPs_PFM.scoreALT) DESC;")
Save(DataBase = db,query = query_9,fileName = 'dati9.csv')

# la media degli ( score di riferimento / score alternativi) per ogni SNPID
# Serve per vedere se le gli SNP che creano uno score alternativo hanno tendenza
# ad aumentare o ridurre lo Score generale
# Immagine visualizzabile sotto il nome di : Rapporto fra ScoreRef e ScoreAlt.jpeg

########################### 10
query_10<-paste("select count(distinct SNPs_PFM.SNPID),PFM.PFMID,PFM.name from SNPs_PFM,
PFM WHERE (SNPs_PFM.PFMID=PFM.PFMID) AND (SNPs_PFM.type = 'match')
GROUP BY PFM.PFMID;") #ORDER BY count(distinct SNPs_PFM.SNPID) DESC

# numero di SNP diversi presenti in ogni PFM

Save(DataBase = db,query = query_10,fileName = 'dati10.csv')

########################### 11
query_11<-paste("select count(SNPs_PFM.SNPID),count(distinct SNPs_PFM.SNPID),PFM.PFMID
from (( SNPs_PFM INNER JOIN PFM ON (SNPs_PFM.PFMID=PFM.PFMID)) INNER JOIN
SNPs ON (SNPs_PFM.SNPID=SNPs.SNPID))
WHERE (SNPs_PFM.type = 'match') AND (SNPs.mafTOPMed IS NOT NULL) AND
(SNPs.maf1000genomes IS NOT NULL)
GROUP BY PFM.PFMID ORDER BY count(distinct SNPs_PFM.SNPID) DESC;")

# conta il numero dei diversi SNP per ogni PFM
# dove il dato deve essere consistente

Save(DataBase = db,query = query_11,fileName = 'dati11.csv')

########################### 12 
query_12<-paste("select count(SNPs_PFM.SNPID), AVG(SNPs_PFM.scoreRef/SNPs_PFM.scoreALT)
FROM SNPs_PFM,PFM WHERE (SNPs_PFM.PFMID=PFM.PFMID) AND SNPs_PFM.fileType='broad'
AND (SNPs_PFM.type = 'match') 
GROUP BY SNPs_PFM.SNPID;")

# per ogni SNPID riporta la frequenza, la media fra ScoreRef ed Alt che quello SNP porta
# file di tipo match and broad
Save(DataBase = db,query = query_12,fileName = 'dati12.csv')

########################### 13
query_13<-paste("SELECT SNPs_FunctionalElement.ElementID, count(SNPs.SNPID) , count(distinct SNPs_FunctionalElement.SNPID)
from SNPs_FunctionalElement, SNPs WHERE SNPs_FunctionalElement.SNPID=SNPs.SNPID AND SNPs_FunctionalElement.fileType='broad'
GROUP BY SNPs_FunctionalElement.ElementID;") 
# Seleziona IDElementoFunzionale, count SNPID, count distinct SNPID per ogni elemento funzionale 
# broad type
Save(DataBase = db,query = query_13,fileName = 'dati13.csv')

########################### 14
query_14<-paste("select count(distinct SNPs_FunctionalElement.SNPID),
SNPs.chrom from SNPs_FunctionalElement
INNER JOIN SNPs USING (SNPID) group by SNPs.chrom;") 
# Conta il numero di tutti gli SNP diversi per Chr
Save(DataBase = db,query = query_14,fileName = 'dati14.csv')

########################### 14_1
query_14_1<-paste("select count(SNPs_FunctionalElement.ElementID),
SNPs.chrom from SNPs_FunctionalElement
INNER JOIN SNPs USING (SNPID) group by SNPs.chrom;") 
# Conta il numero di Elementi funzionali per Chr
# teoricamente per ogni CHR, il numero degli elementi dovrebbe essere uguale
# dato che ogni elemento funzionale dovrebbe trovarsi in ogni CHR
Save(DataBase = db,query = query_14_1,fileName = 'dati14_1.csv')

########################### 15
query_15<-paste("select count(SNPs_FunctionalElement.SNPID), SNPs_FunctionalElement.ElementID, 
count(SNPs_FunctionalElement.CELLLINEID) from SNPs_FunctionalElement
INNER JOIN SNPs USING (SNPID) group by SNPs_FunctionalElement.ElementID;")
# Conta il numero degli SNP che sono associati, ognuno con un elemento funzionale diverso 
Save(DataBase = db,query = query_15,fileName = 'dati15.csv')

########################### 16
query_16<-paste("select ElementID,count(ElementID) 
                from SNPs_FunctionalElement WHERE fileType='broad' group by ElementID;")
# Conta le frequenze di ogni elemento 
Save(DataBase = db,query = query_16,fileName = 'dati16.csv')


########################### 17
############## IN SEGUITO ci sono 4 query per recuperare gli SNP differenziando per: gene, SNP di riferimento, file type, ElementID
#
#               gene AR con filetype di tipo 'Broad' , suddivisi nei 4 nucleotidi di riferimento 
#                 prendendo solo nucleotidi di tipo MATCH
#                    -SNPs_FunctionalElement.fileType(2)
#                    -SNPs.ref(4) : A,C,T,G
#                    -SNPs_PFM.type(4) : match, unmatch, addition, delition
#                    -PFM_GeneSymbols_GENESYMBOLID(6) : AR , GR , PGR, HR, ESR1, ESR2
#      Numero di combinazioni possibili di Query diverse = 2*4*6*4 = 192 query diverse
#      escludendo i 4 tipi di Nucleotidi dello SNP alternativo

# Mostro un unico tipo di query per non riscriverle tutte. 

# Le combinazioni sono: 5(geni)*2(fileType)*4(SNPsRef)*4(SNPstype)*3(FunctionalElement[promoter,enhancerON,enhancerOFF])

#  GENE: AR | file Type: broad | SNPs type: MATCH | Element: promoter, enhancerON, enhancerOFF 
query_17<-paste("select count(SNPs_FunctionalElement.SNPID), SNPs_FunctionalElement.ElementID,
                count(SNPs_FunctionalElement.CELLLINEID) from SNPs_FunctionalElement 
                INNER JOIN SNPs USING (SNPID) WHERE SNPs_FunctionalElement.countExperiments>2 AND
                SNPs_FunctionalElement.fileType='broad' AND SNPs_FunctionalElement.ElementID IN (",SNP_FE,")
                SNPs.SNPID IN (select SNPs_PFM.SNPID from SNPs_PFM LEFT JOIN PFM_GeneSymbols ON (PFMID) 
                WHERE PFM_GeneSymbols_GENESYMBOLID=24 and SNPs_PFM.type='match' group by SNPs_PFM.SNPID )
                group by SNPs_FunctionalElement.ElementID,SNPs_FunctionalElement.CELLLINEID;")


Save(DataBase = db,query = query_17,fileName = 'dati17.csv')

########################### 18

query_18<-paste("select count(distinct SNPs_FunctionalElement.SNPID), count(distinct SNPs_FunctionalElement.ElementID), 
SNPs_FunctionalElement.CELLLINEID from SNPs_FunctionalElement
INNER JOIN SNPs USING (SNPID) group by SNPs_FunctionalElement.CELLLINEID order by SNPs_FunctionalElement.CELLLINEID DESC;")

# seleziona ogni singola linea cellulare e conta tutti i differenti SNP trovati su quella linea cellulare
# e conta ogni elemento funzionale diverso presente

Save(DataBase = db,query = query_18,fileName = 'dati18.csv')

########################### 18_1

query_18_1<-paste("select count(distinct SNPs_FunctionalElement.SNPID), count(distinct SNPs_FunctionalElement.ElementID), 
SNPs_FunctionalElement.CELLLINEID from SNPs_FunctionalElement
INNER JOIN SNPs USING (SNPID) WHERE ",SNP_FE[1]," OR ",SNP_FE[2]," OR ",SNP_FE[3],"  
group by SNPs_FunctionalElement.CELLLINEID,SNPs.ref order by SNPs_FunctionalElement.CELLLINEID DESC;")
# seleziona ogni singola linea cellulare e conta tutti i differenti SNP trovati su quella linea cellulare
# e conta ogni elemento funzionale diverso presente. Raggruppa per un ulteriore divisione degli SNP di riferimento
# ho quindi un numeroi di categorie uguali a 4(num_nucleotidi) * 6(n_geni_di_interesse) = 24 gruppi diversi
# da raggruppare secondo un Bar Chart con uno stack dei differenti nucleotidi per ogni gene
# Gli elementi funzionali devono essere quelli di interesse

Save(DataBase = db,query = query_18,fileName = 'dati18.csv')

########################### 19
min_pos = 10000
max_pos = 10100
chrom = 3 
query_19<-paste("select SNP.pos 
                 from SNPs_FunctionalElement,SNPs WHERE SNPs_FunctionalElement.SNPID=SNPs.SNPID
                 AND SNPs_FunctionalElement.fileType='broad' AND ",SNP_FE[1]," OR ",SNP_FE[2]," OR ",SNP_FE[3]," 
                 AND SNPs_FunctionalElement.CELLINEID IN (",IDlinee_cellulari_di_interesse,") AND SNP.chrom ==",chrom,"
                 AND SNP.pos < ",max_pos," AND SNP.pos > ",min_pos," GROUP BY SNPs_FunctionalElement.CELLINEID;")

Save(DataBase = db,query = query_19,fileName = 'dati19.csv')

########################### 20

query_20<-paste("select count(distinct SNPs_FunctionalElement.SNPID), count(distinct SNPs_FunctionalElement.ElementID),  
count(SNPs_FunctionalElement.ElementID),
SNPs.chrom from SNPs_FunctionalElement INNER JOIN SNPs USING (SNPID) 
group by SNPs.chrom ORDER BY count(distinct SNPs_FunctionalElement.SNPID) DESC;")
Save(DataBase = db,query = query_20,fileName = 'dati20.csv')
# Seleziona per ogni cromosoma il numero dei diversi SNP associati, 
# ed il numero dei diversi elementi funzionali associati
#
# Per ogni Chr conta diversi elementi, diverse cellline, diversi SNPs
# TUTTI I CHR HANNO : 755 |238 come num Elementi e Cellline, mentre ChrY ha : 242 |166 | Y 

########################### 21

query_21<-paste("select SNPs_PFM.SNPID) ,(SNPs_PFM.scoreRef/SNPs_PFM.scoreALT),
PFM.PFMID FROM SNPs_PFM INNER JOIN 
PFM ON (SNPs_PFM.PFMID=PFM.PFMID) WHERE (SNPs_PFM.type = 'match') AND (PFM.) 
GROUP BY PFM.PFMID and SNPs_PFM.SNPID;")
# Seleziona ogni SNP presente in ogni PFM e calcola per ogni SNP uno Score 
# prendendo Ref/Alt, per verificare se lo score di affinita' e' aumentato (>1)
# o diminuito (<1)
Save(DataBase = db,query = query_21,fileName = 'dati21.csv')

########################### 24

query_24<-paste("select count(SNPs_PFM.SNPID), count(distinct PFM.PFMID) 
                from ((SNPs_PFM INNER JOIN PFM ON SNPs_PFM.PFMID=PFM.PFMID) 
                INNER JOIN SNPs_FunctionalElement ON SNPs_FunctionalElement.SNPID=SNPs_PFM.SNPID) 
                WHERE(SNPs_PFM.type='deletion') AND (SNPs_FunctionalElement.fileType='broad') 
                group by PFM.PFMID;")
# seleziona il numero di SNP associati ad ogni PFM dove la modifica e'la DELEZIONE
# ed il file type e' BROAD
# di questo si possono fare almeno 8 combinazioni con fileType(broad,narrow) e
# tipo di modifica: match, unmatch, addition, delition
Save(DataBase = db,query = query_24,fileName = 'dati24.csv')

########################### 25

query_25<-paste("select SNPs_PFM.SNPID, (SNPs_PFM.scoreRef/SNPs_PFM.scoreALT) , SNPs.pos, SNPs_PFM.type
FROM ((SNPs_PFM INNER JOIN PFM ON (SNPs_PFM.PFMID=PFM.PFMID))
INNER JOIN SNPs ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE (SNPs_PFM.type IN (",lista_type,"))
AND SNPs_PFM.SNPID IN ( select SNPs_PFM.SNPID FROM SNPs_PFM LEFT JOIN PFM_GeneSymbols 
ON (SNPs_PFM.PFMID=PFM_GeneSymbols.PFMID) WHERE PFM_GeneSymbols.GENESYMBOLID == 24)                
GROUP BY SNPs_PFM.type, SNPs_PFM.SNPID;")

# seleziona per ogni SNP di Androgen Receptor
# il rapporto fra Ref/Alt
# la posizione dello SNP ed il Cromosoma dove il tipo di modifica e' MATCH/CHANGE/ADDITION/DELItiON 

Save(DataBase = db,query = query_25,fileName = 'dati25.csv')
########################### 26

query_26<-paste("select count(SNPs_PFM.SNPID),SNPs_PFM.SNPID , (SNPs_PFM.scoreALT/SNPs_PFM.scoreRef), SNPs.pos 
FROM ((SNPs_PFM INNER JOIN PFM ON (SNPs_PFM.PFMID=PFM.PFMID)) 
INNER JOIN SNPs ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE ( (SNPs_PFM.type IN ",lista_type,") AND
PFM.PFMID IN ( SELECT PFMID FROM PFM_GeneSymbols WHERE GENESYMBOLID==24)
GROUP BY SNPs.SNPID,SNPs_PFM.type ;")

# seleziona per ogni SNPID, il rapporto fra Ref/Alt di AR
# la posizione dello SNP ed il Cromosoma 
Save(DataBase = db,query = query_26,fileName = 'dati26.csv')

########################### 26_AR

query_26_AR<-paste("select SNP.pos
FROM ((SNPs_PFM INNER JOIN PFM ON (SNPs_PFM.PFMID=PFM.PFMID)) 
INNER JOIN SNPs ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE (SNPs_PFM.type IN ",lista_type,") AND
PFM.PFMID IN ( SELECT PFMID FROM PFM_GeneSymbols WHERE GENESYMBOLID==24);")
Save(DataBase = db,query = query_26_AR_delition,fileName = 'dati_26_AR.csv')


########################### 26_1 ESR1
query_26_ESR1<-paste("select count(SNPs_PFM.SNPID),SNPs_PFM.type
FROM ((SNPs_PFM INNER JOIN PFM ON (SNPs_PFM.PFMID=PFM.PFMID)) 
INNER JOIN SNPs ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE ( (SNPs_PFM.type IN ",lista_type,") AND
PFM.PFMID IN ( SELECT PFMID FROM PFM_GeneSymbols WHERE GENESYMBOLID==401)
GROUP BY SNPs.SNPID;")

Save(DataBase = db,query = query_26_ESR1,fileName = 'dati26_ESR1.csv')

########################### 26_2 ESR2
query_26_ESR2<-paste("select SNP.pos
FROM ((SNPs_PFM INNER JOIN PFM ON (SNPs_PFM.PFMID=PFM.PFMID)) 
INNER JOIN SNPs ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE ( (SNPs_PFM.type IN ",lista_type,") AND
PFM.PFMID IN ( SELECT PFMID FROM PFM_GeneSymbols WHERE GENESYMBOLID==402);")

Save(DataBase = db,query = query_26_ESR2,fileName = 'dati26_ESR2.csv')
########################### 26_3 GR
query_26_GR<-paste("select SNP.pos
FROM ((SNPs_PFM INNER JOIN PFM ON (SNPs_PFM.PFMID=PFM.PFMID)) 
INNER JOIN SNPs ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE ( (SNPs_PFM.type IN ",lista_type,") AND
PFM.PFMID IN ( SELECT PFMID FROM PFM_GeneSymbols WHERE GENESYMBOLID==1055);")

Save(DataBase = db,query = query_26_GR,fileName = 'dati26_GR.csv')
########################### 26_4 HR
query_26_HR<-paste("select SNP.pos
FROM ((SNPs_PFM INNER JOIN PFM ON (SNPs_PFM.PFMID=PFM.PFMID)) 
INNER JOIN SNPs ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE ( (SNPs_PFM.type IN ",lista_type,") AND
PFM.PFMID IN ( SELECT PFMID FROM PFM_GeneSymbols WHERE GENESYMBOLID==1056);")

Save(DataBase = db,query = query_26_HR,fileName = 'dati26_HR.csv')

########################### 26_5 PGR
query_26_PGR<-paste("select SNP.pos
FROM ((SNPs_PFM INNER JOIN PFM ON (SNPs_PFM.PFMID=PFM.PFMID)) 
INNER JOIN SNPs ON (SNPs_PFM.SNPID=SNPs.SNPID)) WHERE ( (SNPs_PFM.type IN ",lista_type,") AND
PFM.PFMID IN ( SELECT PFMID FROM PFM_GeneSymbols WHERE GENESYMBOLID==1117);")
Save(DataBase = db,query = query_26_PGR,fileName = 'dati26_PGR.csv')

########################### 27
query_27<-paste("select count(distinct SNPs_FunctionalElement.SNPID), count( SNPs_FunctionalElement.ElementID), 
SNPs.chrom from SNPs_FunctionalElement INNER JOIN SNPs USING (SNPID) 
group by SNPs.chrom ORDER BY SNPs.chrom;")

# selezoni il numero dei diversi SNP e il TOT degli elementi Funzionali che cadono in ogni CHR
# posso cosi' vedere i CHR piu' colpiti e quelli in cui ci son piu' elementi associati

# NON USO DISTINCTs per Elementi e Cellline, cosi' posso capire il Peso delle mutazioni in quel chr rispetto agli altri
# Per ogni Chr conta diversi elementi, diverse cellline, diversi SNPs
# TUTTI I CHR HANNO : 755 |238 come num Elementi e Cellline, mentre ChrY ha : 242 |166 | Y 
Save(DataBase = db,query = query_27,fileName = 'dati27.csv')

########################### 28

query_28<-paste("select SNPs.SNPID,count(distinct SNPs_FunctionalElement.ElementID) 
from SNPs,SNPs_FunctionalElement WHERE SNPs.SNPID=SNPs_FunctionalElement.SNPID AND SNPs_FunctionalElement.fileType='broad' 
group by SNPs.SNPID order By count(distinct SNPs_FunctionalElement.ElementID) DESC;") 
# Per ogni SNPID conta quanti DIVERSI elementi funzionali ci sono associati ad esso, e riportali in ordine decrescente
# tipo di File BROAD
Save(DataBase = db,query = query_28,fileName = 'dati28.csv')

########################### 29

query_29<-paste("select SNPs.SNPID, count(distinct SNPs_FunctionalElement.CELLLINEID) 
from SNPs,SNPs_FunctionalElement WHERE SNPs.SNPID=SNPs_FunctionalElement.SNPID AND SNPs_FunctionalElement.fileType='broad' 
group by SNPs.SNPID order By count(distinct SNPs_FunctionalElement.CELLLINEID) DESC;") 
# Per ogni SNPID conta quanti DIVERSE CellLine ci sono associate ad esso, e riportali in ordine decrescente
# tipo di File BROAD
Save(DataBase = db,query = query_29,fileName = 'dati29.csv')

########################### 30 
# PER DISCRIMINARE fra gli SNP che hanno piu' impatto sul sito di legame alla sequenza
# riporta tutti i valori della PFM per ogni singolo SNP dove:
# lo score alternativo differisce di almeno il 10% rispetto allo score di riferimento
#(SNPs_PFM.scoreALT-SNPs_PFM.scoreRef)/SNPs_PFM.scoreRef)>0,1)  OR 
#((SNPs_PFM.scoreALT-SNPs_PFM.scoreRef)/SNPs_PFM.scoreRef)<(-0,1)

# cerca gli SNPs 'match' che hanno piu'impatto sullo score 
query_30 <- paste("select SNPs.rsid, count(SNPs.rsid)
                   WHERE (SNPs_PFM.PFMID=PFM.PFMID) AND (SNPs_PFM.SNPID=SNPs.SNPID) AND 
                   ((((SNPs_PFM.scoreALT-SNPs_PFM.scoreRef)/SNPs_PFM.scoreRef)>0,1)  OR 
                   ((SNPs_PFM.scoreALT-SNPs_PFM.scoreRef)/SNPs_PFM.scoreRef)<(-0,1)) AND 
                   (SNPs_PFM.type='match') group by count(SNPs.rsid) DESC;")



# PER DISCRIMINARE fra gli SNP che hanno piu' impatto sul sito di legame alla sequenza
# SNP di tipo MATCH

Save(DataBase = db,query = query_30,fileName = 'dati30.csv')

# 30_1
# cerca gli SNPs 'addition' che hanno piu'impatto sullo score 
query_30_1 <- paste("select SNPs.rsid, count(SNPs.rsid)
                   WHERE (SNPs_PFM.PFMID=PFM.PFMID) AND (SNPs_PFM.SNPID=SNPs.SNPID) AND 
                   ((((SNPs_PFM.scoreALT-SNPs_PFM.scoreRef)/SNPs_PFM.scoreRef)>0,1)  OR 
                   ((SNPs_PFM.scoreALT-SNPs_PFM.scoreRef)/SNPs_PFM.scoreRef)<(-0,1)) AND 
                   (SNPs_PFM.type='addition') group by count(SNPs.rsid) DESC;")
Save(DataBase = db,query = query_30_1,fileName = 'dati30_1.csv')

# 30_2
# cerca gli SNPs 'delition' che hanno piu'impatto sullo score 
query_30_2 <- paste("select SNPs.rsid, count(SNPs.rsid)
                   WHERE (SNPs_PFM.PFMID=PFM.PFMID) AND (SNPs_PFM.SNPID=SNPs.SNPID) AND 
                   ((((SNPs_PFM.scoreALT-SNPs_PFM.scoreRef)/SNPs_PFM.scoreRef)>0,1)  OR 
                   ((SNPs_PFM.scoreALT-SNPs_PFM.scoreRef)/SNPs_PFM.scoreRef)<(-0,1)) AND 
                   (SNPs_PFM.type='delition') group by count(SNPs.rsid) DESC;")
Save(DataBase = db,query = query_30_2,fileName = 'dati30_2.csv')

# 30_3
# cerca gli SNPs 'delition' che hanno piu'impatto sullo score 
query_30_3 <- paste("select SNPs.rsid, count(SNPs.rsid)
                   WHERE (SNPs_PFM.PFMID=PFM.PFMID) AND (SNPs_PFM.SNPID=SNPs.SNPID) AND 
                   ((((SNPs_PFM.scoreALT-SNPs_PFM.scoreRef)/SNPs_PFM.scoreRef)>0,1)  OR 
                   ((SNPs_PFM.scoreALT-SNPs_PFM.scoreRef)/SNPs_PFM.scoreRef)<(-0,1)) AND 
                   (SNPs_PFM.type='delition') group by count(SNPs.rsid) DESC;")

Save(DataBase = db,query = query_30_3,fileName = 'dati30_3.csv')

########################### 30_4 all together
# seleziona tutti gli SNPs che apportano importanti modifiche al sito di legame
# e l'importanza e' data da { | AltScore-RefScore | / MaxScore } > 0.1

query_30_4 <- paste("select SNPs_PFM.SNPID, SNPs_PFM.type, ((SNPs_PFM.scoreALT-SNPs_PFM.scoreRef)/PFM.maxScore)
                   from SNPs_PFM, PFM
                   WHERE (SNPs_PFM.PFMID=PFM.PFMID) 
                   ((((SNPs_PFM.scoreALT-SNPs_PFM.scoreRef)/PFM.maxScore)>0,10)  OR 
                   ((SNPs_PFM.scoreALT-SNPs_PFM.scoreRef)/PFM.maxScore)<(-0,10)) AND 
                   (SNPs_PFM.type=",lista_type,") group by SNPs_PFM.SNPID;")

Save(DataBase = db,query = query_30_4,fileName = 'dati30_4.csv')

########################### 31
# Discrimina per Elemento Funzionale
# trova le CellLines ID ed i nomi delle CellLines con SNPs in assoluto dove
# associati ad elementi funzionali in PROMOTER 755
# file type BROAD
query_31<-paste("select CellLines.CELLLINEID, CellLines.name, count(SNPs_FunctionalElement.SNPID) from CellLines 
                  INNER JOIN SNPs_FunctionalElement 
                ON CellLines.CELLLINEID=SNPs_FunctionalElement.CELLLINEID 
               WHERE SNPs_FunctionalElement.fileType='broad' and SNPs_FunctionalElement.ElementID=755
               group by CellLines.CELLLINEID ORDER BY count(SNPs_FunctionalElement.SNPID) DESC;") 


Save(DataBase = db,query = query_31,fileName = 'dati31.csv')

########################### 31_1
# trova le ID ed i nomi delle CellLine con piu'mutazioni in assoluto dove
# associati ad elementi funzionali in EnhancerOFF 475 and 471 and not 477
# file type BROAD

query_31_1<-paste("select CellLines.CELLLINEID, CellLines.name, count(SNPs_FunctionalElement.SNPID) from CellLines 
                  INNER JOIN SNPs_FunctionalElement 
                  ON CellLines.CELLLINEID=SNPs_FunctionalElement.CELLLINEID 
                  WHERE SNPs_FunctionalElement.fileType='broad' and (SNPs_FunctionalElement.ElementID=475 AND
                  SNPs_FunctionalElement.ElementID=471 AND NOT SNPs_FunctionalElement.ElementID=477)
                  group by CellLines.CELLLINEID ORDER BY count(SNPs_FunctionalElement.SNPID) DESC;") 

Save(DataBase = db,query = query_31_1,fileName = 'dati31_1.csv')

########################### 31_2
# trova le ID ed i nomi delle CellLine con piu'mutazioni in assoluto dove
# associati ad elementi funzionali in EnhancerON 754 or (477 and not 475)
# file type BROAD
query_31_2<-paste("select CellLines.CELLLINEID, CellLines.name, count(SNPs_FunctionalElement.SNPID) from CellLines 
                  INNER JOIN SNPs_FunctionalElement 
                  ON CellLines.CELLLINEID=SNPs_FunctionalElement.CELLLINEID 
                  WHERE SNPs_FunctionalElement.fileType='broad' and (SNPs_FunctionalElement.ElementID=754
                  OR (SNPs_FunctionalElement.ElementID=477 and NOT SNPs_FunctionalElement.ElementID=475)
                  group by CellLines.CELLLINEID ORDER BY count(SNPs_FunctionalElement.SNPID) DESC;") 


Save(DataBase = db,query = query_31_2,fileName = 'dati31_2.csv')

########################### 32

query_32<-paste("select FunctionalElement.ElementID, count(SNPs_FunctionalElement.SNPID), 
               FunctionalElement.name
               from SNPs_FunctionalElement INNER JOIN FunctionalElement
               ON SNPs_FunctionalElement.ElementID= FunctionalElement.ElementID
               where fileType='broad' group by FunctionalElement.ElementID 
               ORDER BY count(SNPs_FunctionalElement.SNPID) DESC ;")
 # Per ogni elemento funzionale, riporta il numero di SNP non distinti associati
Save(DataBase = db,query = query_32,fileName = 'dati32.csv')

########################### 33

query_33<-paste ("select * from FunctionalElement where (name like 'H2%') or 
               (name like 'H3%') or (name like 'H4%');")
 # Seleziona tutti i nomi e le ID  degli elementi funzionali con associazione agli istoni H2, H3 o H4
Save(DataBase = db,query = query_33,fileName = 'dati33.csv')

########################### 35
# Seleziona tutte le cellLine Nome ed ID ed Elemento funzionale (file Type Broad) 
# dove per ogni elemento funzionale riporta la CellLine e conta il numero dei 
# diversi SNP associati a quella CellLine con quel Elemento Funzionale
query_35<-paste ("select CellLines.CELLLINEID, CellLines.name, 
               SNPs_FunctionalElement.ElementID, count(SNPs_FunctionalElement.SNPID)
               from SNPs_FunctionalElement, CellLines 
               WHERE SNPs_FunctionalElement.CELLLINEID = CellLines.CELLLINEID
               AND where fileType='broad' 
               group by SNPs_FunctionalElement.ElementID AND CellLines.CELLLINEID 
               ORDER by count(SNPs_FunctionalElement.SNPID) DESC;")

Save(DataBase = db,query = query_35,fileName = 'dati35.csv')

########################## 37
# seleziono la cellLineID, cellLineName, nomeElementoFunzionale, IDelementoFunzionale ed il numero tot degli SNP
# per ogni CellLine e per ogni Elemento funzionale

query_37<-paste ("select CellLines.CELLLINEID, CellLines.name, FunctionalElement.name, 
               FunctionalElement.ElementID, count(SNPs_FunctionalElement.SNPID)
               from ((SNPs_FunctionalElement INNER JOIN Celllines 
               ON SNPs_FunctionalElement.CELLLINEID = Celllines.CELLLINEID)
               INNER JOIN FunctionalElement 
               ON SNPs_FunctionalElement.ElementID=FunctionalElement.ElementID) 
               where fileType='broad' 
               group by CellLines.CELLLINEID and FunctionalElement.ElementID;") # cambio di group by

Save(DataBase = db,query = query_37,fileName = 'dati37.csv')

########################## 38
# seleziona le volte in cui un Elemento Funzionale viene associato ad uno SNPs 
# riporta gli Elementi Funzionali maggiormente trovati in associazione con SNPs

query_38<- paste("select FunctionalElement.ElementID, count(SNPs_FunctionalElement.SNPID)  
               from (SNPs_FunctionalElement LEFT JOIN FunctionalElement
               ON SNPs_FunctionalElement.ElementID=FunctionalElement.ElementID) 
               where fileType='narrow' group by FunctionalElement.ElementID 
               ORDER BY count(FunctionalElement.ElementID) DESC;")
Save(DataBase = db,query = query_38,fileName = 'dati38.csv')

#############################################################
# AR 24
# ESR1 401
# ESR2 402
# GR 1055
# HR 1056
# PGR 1117

# EnhancerON = 754 or (477 and not 475)
# EnhancerOFF = 475 and 471 and not 477
# Promoter = 755
########################################################
# AR_EnhancerON
query_AR_EnhancerON <- paste("select (SNPs_PFM.scoreAlt-SNPs_PFM.scoreRef)/SNPs_PFM.scoreRef from SNPs_PFM 
                  INNER JOIN SNPs_FunctionalElement 
                  ON SNPs_PFM.SNPID=SNPs_FunctionalElement.SNPID 
                  INNER JOIN PFM_GeneSymbols
                  ON SNPs_PFM.PFMID=PFM_GeneSymbols.PFMID
                  WHERE SNPs_FunctionalElement.fileType='broad' 
                  and (SNPs_FunctionalElement.ElementID=754
                  OR (SNPs_FunctionalElement.ElementID=477 and NOT SNPs_FunctionalElement.ElementID=475)
                  and PFM_GeneSymbols.GENESYMBOLID==24
                  group by SNPs_PFM.SNPID;")
Save(DataBase = db,query = query_AR_EnhancerON,fileName = 'AR_EnhancerON.csv')

# AR_EnhancerOFF
query_AR_EnhancerOFF <- paste("select (SNPs_PFM.scoreAlt-SNPs_PFM.scoreRef)/SNPs_PFM.scoreRef from SNPs_PFM 
                  INNER JOIN SNPs_FunctionalElement 
                  ON SNPs_PFM.SNPID=SNPs_FunctionalElement.SNPID 
                  INNER JOIN PFM_GeneSymbols
                  ON SNPs_PFM.PFMID=PFM_GeneSymbols.PFMID
                  WHERE SNPs_FunctionalElement.fileType='broad' 
                  and (SNPs_FunctionalElement.ElementID=475
                  and SNPs_FunctionalElement.ElementID=471 and NOT SNPs_FunctionalElement.ElementID=477)
                  and PFM_GeneSymbols.GENESYMBOLID==24
                  group by SNPs_PFM.SNPID;") # 475 and 471 and not 477
Save(DataBase = db,query = query_AR_EnhancerOFF,fileName = 'AR_EnhancerOFF.csv')
# AR_Promoter
query_AR_Promoter <- paste("select (SNPs_PFM.scoreAlt-SNPs_PFM.scoreRef)/SNPs_PFM.scoreRef from SNPs_PFM 
                  INNER JOIN SNPs_FunctionalElement 
                  ON SNPs_PFM.SNPID=SNPs_FunctionalElement.SNPID 
                  INNER JOIN PFM_GeneSymbols
                  ON SNPs_PFM.PFMID=PFM_GeneSymbols.PFMID
                  WHERE SNPs_FunctionalElement.fileType='broad' 
                  and (SNPs_FunctionalElement.ElementID=755)
                  and PFM_GeneSymbols.GENESYMBOLID==24
                  group by SNPs_PFM.SNPID;") # 475 and 471 and not 477
Save(DataBase = db,query = query_AR_Promoter,fileName = 'AR_Promoter.csv')
# PGR_EnhancerON
query_PGR_EnhancerON <- paste("select (SNPs_PFM.scoreAlt-SNPs_PFM.scoreRef)/SNPs_PFM.scoreRef from SNPs_PFM 
                  INNER JOIN SNPs_FunctionalElement 
                  ON SNPs_PFM.SNPID=SNPs_FunctionalElement.SNPID 
                  INNER JOIN PFM_GeneSymbols
                  ON SNPs_PFM.PFMID=PFM_GeneSymbols.PFMID
                  WHERE SNPs_FunctionalElement.fileType='broad' 
                  and (SNPs_FunctionalElement.ElementID=754
                  OR (SNPs_FunctionalElement.ElementID=477 and NOT SNPs_FunctionalElement.ElementID=475)
                  and PFM_GeneSymbols.GENESYMBOLID==1117
                  group by SNPs_PFM.SNPID;")
Save(DataBase = db,query = query_PGR_EnhancerON,fileName = 'PGR_EnhancerON.csv')
# PGR_EnhancerOFF
query_PGR_EnhancerOFF <- paste("select (SNPs_PFM.scoreAlt-SNPs_PFM.scoreRef)/SNPs_PFM.scoreRef from SNPs_PFM 
                  INNER JOIN SNPs_FunctionalElement 
                  ON SNPs_PFM.SNPID=SNPs_FunctionalElement.SNPID 
                  INNER JOIN PFM_GeneSymbols
                  ON SNPs_PFM.PFMID=PFM_GeneSymbols.PFMID
                  WHERE SNPs_FunctionalElement.fileType='broad' 
                  and (SNPs_FunctionalElement.ElementID=475
                  and SNPs_FunctionalElement.ElementID=471 and NOT SNPs_FunctionalElement.ElementID=477)
                  and PFM_GeneSymbols.GENESYMBOLID==1117
                  group by SNPs_PFM.SNPID;") # 475 and 471 and not 477
Save(DataBase = db,query = query_PGR_EnhancerOFF,fileName = 'PGR_EnhancerOFF.csv')
# PGR_Promoter
query_PGR_Promoter <- paste("select (SNPs_PFM.scoreAlt-SNPs_PFM.scoreRef)/SNPs_PFM.scoreRef from SNPs_PFM 
                  INNER JOIN SNPs_FunctionalElement 
                  ON SNPs_PFM.SNPID=SNPs_FunctionalElement.SNPID 
                  INNER JOIN PFM_GeneSymbols
                  ON SNPs_PFM.PFMID=PFM_GeneSymbols.PFMID
                  WHERE SNPs_FunctionalElement.fileType='broad' 
                  and (SNPs_FunctionalElement.ElementID=755)
                  and PFM_GeneSymbols.GENESYMBOLID==1117
                  group by SNPs_PFM.SNPID;") # 475 and 471 and not 477
Save(DataBase = db,query = query_PGR_Promoter,fileName = 'PGR_Promoter.csv')

