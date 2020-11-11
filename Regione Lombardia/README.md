
# Regione Lombardia
Procedure per la trasformazione di dataset pubblicati dalla Regione Lombardia sul sito https://www.dati.lombardia.it/

I dati di input si trasformano in dati in formato xml, in base agli schema elaborati per le schede ICCD.

I dati di input (formato csv) per le procedure sono:
  - Architetture https://www.dati.lombardia.it/api/views/kf9b-rj2t/rows.csv?accessType=DOWNLOAD
  - Reperti Archeologici conservati nei Musei https://www.dati.lombardia.it/api/views/97ng-v559/rows.csv?accessType=DOWNLOAD
  - Opere d'Arte conservate nei Musei https://www.dati.lombardia.it/api/views/dsrv-9ish/rows.csv?accessType=DOWNLOAD
  - Patrimonio Scientifico Tecnologico conservato nei Musei https://www.dati.lombardia.it/api/views/2k8u-uj4r/rows.csv?accessType=DOWNLOAD

### requisiti
Java 8 + maven

### installazione
`> mvn validate clean package`

### esecuzione
`> java -Dfile.encoding=UTF-8 -jar target/rdfLombardia-0.0.1-jar-with-dependencies.jar <output folder>`


