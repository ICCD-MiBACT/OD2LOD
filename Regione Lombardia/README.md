
# Open Data Lombardia
Procedure per la trasformazione di [dataset dei beni culturali pubblicati dalla Regione Lombardia](https://www.dati.lombardia.it/)

I contenuti dei dataset sono ricondotti dal formatio csv a modelli conformi alle normative ICCD per la rappresentazione in RDF mediante le ontologie e le trasformazioni del progetto [ArCo](https://github.com/ICCD-MiBACT/ArCo).

- [Architetture](https://www.dati.lombardia.it/api/views/kf9b-rj2t/rows.csv?accessType=DOWNLOAD)
- [Reperti Archeologici conservati nei Musei](https://www.dati.lombardia.it/api/views/97ng-v559/rows.csv?accessType=DOWNLOAD)
- [Opere d'Arte conservate nei Musei](https://www.dati.lombardia.it/api/views/dsrv-9ish/rows.csv?accessType=DOWNLOAD)
- [Patrimonio Scientifico Tecnologico conservato nei Musei](https://www.dati.lombardia.it/api/views/2k8u-uj4r/rows.csv?accessType=DOWNLOAD)

### requisiti
Java 8 + maven

### installazione
`> mvn validate clean package`

### esecuzione
`> java -Dfile.encoding=UTF-8 -jar target/rdfLombardia-0.0.1-jar-with-dependencies.jar <output folder>`


