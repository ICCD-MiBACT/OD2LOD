
# Provincia Autonoma di Trento
Procedure per la trasformazione del [dataset "Beni Architettonici" dalla Provincia Autonoma di Trento](https://siat.provincia.tn.it/geonetwork/srv/ita/catalog.search#/metadata/p_TN:0bbf21c6-2d9a-4c63-9d5e-50ef8f8b7ec5)

I [dati di input](https://idt.provincia.tn.it/idt/vector/p_TN_0bbf21c6-2d9a-4c63-9d5e-50ef8f8b7ec5.zip) sono trasformati conformemente agli schema ICCD, e quindi in RDF mediante [ArCo rdfizer](https://github.com/oibaf/ArCo/tree/1.2/ArCo-release/rdfizer)

La preparazione del dataset alla elaborazione richiede [ogr2ogr](https://gdal.org/programs/ogr2ogr.html)

### requisiti
Java 8 + maven

### installazione
`> mvn validate clean package`

### esecuzione
`> java -Dfile.encoding=UTF-8 -jar target/rdfTrento-0.0.1-jar-with-dependencies.jar <output folder>`


