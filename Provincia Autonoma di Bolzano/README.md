
# Alto Adige
Procedure per la trasformazione di dataset pubblicati dalla Provincia autonoma di Bolzano sul sito http://daten.buergernetz.bz.it/

I dati di input si trasformano in dati in formato xml, in base agli schema elaborati per le schede ICCD.

I dati di input (formato csv) per le procedure sono:
  - Fotografie http://daten.buergernetz.bz.it/services/kksSearch/collect/lichtbild?q=*:*&fl=*&rows=999999&wt=csv

### requisiti
Java 8 + maven

### installazione
`> mvn validate clean package`

### esecuzione
`> java -Dfile.encoding=UTF-8 -jar target/rdfAltoAdige-0.0.1-jar-with-dependencies.jar <output folder>`


