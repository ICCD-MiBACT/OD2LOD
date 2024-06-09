
# Provincia Autonoma di Trento
Procedure per la trasformazione del [dataset "Beni Architettonici" dalla Provincia Autonoma di Trento](https://siat.provincia.tn.it/geonetwork/srv/ita/catalog.search#/metadata/p_TN:0bbf21c6-2d9a-4c63-9d5e-50ef8f8b7ec5)

I [contenuti del dataset](https://idt.provincia.tn.it/idt/vector/p_TN_0bbf21c6-2d9a-4c63-9d5e-50ef8f8b7ec5.zip) sono ricondotti dal formatio shapefile a modelli conformi alle normative ICCD per la rappresentazione in RDF mediante le ontologie e le trasformazioni del progetto [ArCo](https://github.com/ICCD-MiBACT/ArCo)

### requisiti
Java 8 + maven (la preparazione del dataset alla elaborazione richiede [ogr2ogr](https://gdal.org/programs/ogr2ogr.html))

### installazione
`> mvn validate clean package`

### esecuzione
`> java -Dfile.encoding=UTF-8 -jar target/rdfTrento-0.0.1-jar-with-dependencies.jar <output folder>`


