
# Regione Veneto
Procedure per la trasformazione delle schede dei [beni culturali della Regione Veneto](https://beniculturali.regione.veneto.it) esposti dal servizio

  https://beniculturali.regione.veneto.it/xway-front/application/crv/engine/crv.jsp

I dati in ingresso sono resi conformi ai modelli delle normative ICCD per la rappresentazione in RDF mediante le ontologie e le trasformazioni del progetto [ArCo](https://github.com/ICCD-MiBACT/ArCo).

### requisiti
Java 8 + maven

### installazione
`> mvn validate clean package`

### esecuzione
`> java -Dfile.encoding=UTF-8 -jar target/rdfVeneto-0.0.1-jar-with-dependencies.jar <output folder>`


