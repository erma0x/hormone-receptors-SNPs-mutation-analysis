print("

    Test per la distribuzione uniforme degli SNPs con Chi-squared
  
     utilizzo di: chisq.test()
     
     H0: la distribuzione degli SNPs e' uniforme lungo la regione genica selezionata
     
     H1: la distribuzione degli SNPs non e' uniforme lungo la regione genica selezionata
     
     La selezione della regione genica avviene all'interno della query definendo 
     due variabili, chiamate : min_pos e max_pos, utilizzate per definire gli estremi
     della posizione degli SNPs che vengono riportati dalla query. E' quindi possibile
     definire uno specifico gene o regione non codificante, per scoprire se la distribuzione
     degli SNPs al suo interno non e' casuale.
     
     * guardare la query_19 sul file query.R per maggiori chiarimenti sulla tipologia dei dati
     * questa query ha diversi gradi di customizzazione da parte dell'operatore
")

# query_19 nel file query.R 

"chi quadro sull'adattamento della distribuzione degli SNPs ad una distribuzione uniforme 
fra due intervalli di posizione sul cromosoma (min_pos,max_pos) da definire nella query 19
dati19.csv "
reali<-read.csv(nome_file_dati_reali, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

# range SNP for target specific gene

# example, I want to target a specific gene, and I know the position and the chromosome
max_pos=12001 # UPPER
min_pos=11008 # LOWER
chrom=3 # Chromosome

breaks = 100  
              # deciso a priori, importante per la validazione del test che:
              # breaks < 0,1*nrow(reali)

# raccogliere i dati reali in gruppi(breaks) 
real_bins<-cut(reali, breaks)
massimo<-max(real_bins)
minimo<-min(real_bins)
num_esempi<-length(real_bins)
# dati teorici generati randomicamente con distribuzione uniforme
theoretical<- runif(length(real_bins), min = minimo, max = massimo) 
theoretical_bins<-cut(theoretical,breaks)

test_chi_quadro<-chisq.test(reali, teorici, correct = F, B = 1 )
print(test_chi_quadro)