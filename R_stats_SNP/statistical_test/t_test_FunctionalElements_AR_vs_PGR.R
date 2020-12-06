#########################################################################
print("
    
          T-test di 2 campioni indipendenti con varianza ignota
            
        - X & Y sono 2 geni specifici, vengono confrontati con un t-test
            i valori standardizzati per ogni SNP sui geni scelti (AR, PGR),
            confrontando gli SNP che cadono sul specifici elementi funzionali
        - valore standardizzato ed attribuito per ogni SNP -> [(ref-alt)/ref]
          
          H0: la media dei valori di X e di Y e'uguale
         
         Assumendo che la distribuzione dei valori sia normale
                    X,Y ~ N (Media,SD)
                    
            verificabile attraverso: shapiro.test()

         
         I valori sono per ogni SNP associato,
         a tutti i geni ed a tutti gli elementi funzionali

                X= [(ref-alt)/ref] 
                Y= [(ref-alt)/ref]  
 
         Se nel 95 percento dell'intervallo di confidenza del T-test
         non e' rappresentato lo Zero compreso fra gli estremi, 
         si puo' considerare H0 Falsa
 
         Nel caso in cui H0 risultasse falsa:
         
         Una dei due tipi di cancro presentano mutazioni 
         che richiedono una maggiore alterazione delle sequenze in:
         (enhancerON,promoter,enhancerOFF) ovvero se gli SNPs
         colpiscono diversamente la sequenza a seconda che sia:
         in promoter,enhancer attivi od enhancer non attivi.
         
         In caso contrario, se H0 risulasse vera:
         
         Differenziando per le tipologie di sequenza 
         a seconda degli elementi funzionali associati.
         La quantita' di SNPs, che colpiscono sequenze funzionali non codificanti,
         non differisce fra una linea e l'altra.  

")

fileX=ClearFromSpace(fileDirectory,'AR_EnhancerON.csv')
fileY=ClearFromSpace(fileDirectory,'PGR_EnhancerON.csv') 

X<-read.csv(fileX, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)
Y<-read.csv(fileY, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

normalityX<-shapiro.test(X)
normalityY<-shapiro.test(Y)

print(normalityX)
print(normalityY)

t.test(X,Y) 

##########################################################################

fileX=ClearFromSpace(fileDirectory,'AR_EnhancerOFF.csv')
fileY=ClearFromSpace(fileDirectory,'PGR_EnhancerOFF.csv') #GUARDA FILE';l1rlr;'1,';12,1;',r'1,er'12r;,'1r,';2,r1',r'21

X<-read.csv(fileX, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)
Y<-read.csv(fileY, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

normalityX<-shapiro.test(X)
normalityY<-shapiro.test(Y)

print(normalityX)
print(normalityY)

t.test(X,Y) 

##########################################################################
fileX=ClearFromSpace(fileDirectory,'AR_Promoter.csv')
fileY=ClearFromSpace(fileDirectory,'PGR_Promoter.csv') #GUARDA FILE';l1rlr;'1,';12,1;',r'1,er'12r;,'1r,';2,r1',r'21

X<-read.csv(fileX, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)
Y<-read.csv(fileY, header = T, sep = ",", quote = "\"",dec = ".", fill = TRUE)

normalityX<-shapiro.test(X)
normalityY<-shapiro.test(Y) 

print(normalityX)
print(normalityY)

t.test(X,Y) 
