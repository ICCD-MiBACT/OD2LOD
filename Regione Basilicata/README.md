
# Regione Basilicata
Procedure per la trasformazione dei dataset 
- [Beni culturali – monumentali art. 10 D.Lgs. 42/2004](http://rsdi.regione.basilicata.it/Catalogo/srv/ita/search?hl=ita#|r_basili:51432cdd:160eb042aef:3aa6)
- [Beni paesaggistici art. 142 let. m del D.Lgs. 42/2004 - Zone di interesse archeologico ope legis](http://rsdi.regione.basilicata.it/Catalogo/srv/ita/search?hl=ita#|r_basili:5f2f287a:1736b6720a2:-4d7)
- [Beni culturali – aree archeologiche art. 10 D.Lgs. 42/2004](http://rsdi.regione.basilicata.it/Catalogo/srv/ita/search?hl=ita#|r_basili:-25220c81:1622a02a615:2e32)
- [Beni culturali - archeologici – Tratturi art. 10 del D.Lgs. 42/2004](http://rsdi.regione.basilicata.it/Catalogo/srv/ita/search?hl=ita#|r_basili:4ce48b8:1667da44185:3f77)

I contenuti dei dataset sono ricondotti dal formatio shapefile a modelli conformi alle normative ICCD per la rappresentazione in RDF mediante le ontologie e le trasformazioni del progetto [ArCo](https://github.com/ICCD-MiBACT/ArCo)

### requisiti
Java 8 + maven (la preparazione del dataset alla elaborazione richiede [ogr2ogr](https://gdal.org/programs/ogr2ogr.html))

### installazione
`> mvn validate clean package`

### esecuzione
`> java -Dfile.encoding=UTF-8 -jar target/rdfBasilicata-0.0.1-jar-with-dependencies.jar <output folder>`

