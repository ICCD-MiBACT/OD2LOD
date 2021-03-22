
# Regione Veneto
Procedure per la trasformazione di dataset dalla Regione Veneto

I dati in ingresso sono resi conformi agli schema elaborati per le schede ICCD e modellati in ArCo / RDF.

I parametri per la la configurazione del processo sono dichiarati in src/main/resources/rdfVeneto.properties

### requisiti
Java 8 + maven

### installazione
`> mvn validate clean package`

### esecuzione
`> java -Dfile.encoding=UTF-8 -jar target/rdfVeneto-0.0.1-jar-with-dependencies.jar <output folder>`


