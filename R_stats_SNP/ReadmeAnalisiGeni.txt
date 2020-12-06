
In questa directory riporto: i file di analisi dati, per i geni di interesse.
All'interno ci sono i comandi per scaricare le immagini dei BoxPlot.

Ogni immagine presenta 2 BoxPlot, in cui viene comparato il valore
di (ScoreAlt-ScoreRef)/ScoreMax di ogni SNPs. Viene preso un elemento funzionale 
ed un gene specifico alla volta.

I due Boxplot appartengono alle 2 linee cellulari.

Le linee prese di interesse sono la linea cellulare del Cancro al seno
e la linea cellulare del cancro alla prostata.

Con le query in mySQL seleziono i valori:
 	

valore  =  ( SNPs.scoreALT - SNPs.scoreRef / SNPs.MaxScore )

tabella SNPs del DB snpImpactResource > 
che rappresentano quanto influisce la mutazione SNPs sullo score di affinita'
all' elemento funzionale trovato in associazione a quella sequenza PAM.
Per singolo SNPs il valore puo' essere

 valore > 0 ==> la mutazione comporta una MAGGIORE affinita' dell elemento 
                 funzionale, e dunque piu' interazione (o attivita') 
 		dell' elemento con la sequenza.  

 valore < 0 ==> la mutazione comporta una MINORE affinita' dell elemento 
                 funzionale, e dunque meno interazione (o attivita') 
 		  dell' elemento con la sequenza.  

 valore ~= 0 ==> la sostituzione dello SNPs non comporta un grande cambio
                 di affinita' della sequenza a cui si legano gli elementi 
                 funzionali. Per cui si puo' ritenere che la mutazione sia
                 ininfuente  

Suddivido gli elementi funzionali in 3: EnhancerOFF, EnhancerON e Promoter

Suddivido le query ed i relativi box plot con i geni analizzati. 
      (AR, ESR1, , GR, HR, PGR)

Suddivido le colonne dei box plot per la linea cellulare.

Quindi in ogni immagine sara' rappresentata da un unico gene, con gli SNPs associati
ad un unico elemento funzionale, confrontando contemporaneamente le 2 linee cellulari.

Ogni file contiene una parte che contiene le informazioni base:
-per l'analisi dei dati di interesse
-le funzioni base per il salvataggio dei dati 
-per la gestione delle query con MySql




______________________ PARTE Standard  del file ______________________

All interno di questa parte definisco le funzioni e le variabili base
di tutti gli scripts. Le variabili definiscono: 
- i geni di interesse,
- gli elementi funzionali di interesse associati alle sequenze
   	non codificanti ma funzionali (esempio gli enhancer) 
- le linee cellulari di interesse 
- i diversi tipi di file dati: broad, narrow 
- i diversi tipi di SNPs: match, enhancer, change, addition, delition
- variabili di uso per comodita', come FE, SNP_FE e SNP_FE_all che rappresentano
una comodo utilizzo di esse nelle query di mySQL senza dover riscrivere le condizioni
per cercare un elemento funzionale, piuttosto che un altro



