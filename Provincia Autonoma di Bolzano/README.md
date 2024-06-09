
# Open Data Alto Adige
Procedure per la trasformazione dei [dataset dei beni culturali pubblicati dalla Provincia autonoma di Bolzano](https://data.civis.bz.it/it/dataset?groups=culture&q=&_groups_limit=0)

I contenuti dei dataset sono ricondotti dal formatio csv a modelli conformi alle normative ICCD per la rappresentazione in RDF mediante le ontologie e le trasformazioni del progetto [ArCo](https://github.com/ICCD-MiBACT/ArCo).

- [Fotografie storiche](http://daten.buergernetz.bz.it/services/kksSearch/collect/lichtbild?q=*:*&fl=*&rows=999999&wt=csv "collegamento al dataset in formato csv")

- [Beni culturali](http://dati.retecivica.bz.it/services/kksSearch/collect/select?q=%28B1p_url:*%29%20AND%20%28OB_it:*%29&fl=*&rows=999999&wt=csv "collegamento al dataset in formato csv")

- [Musei](http://daten.buergernetz.bz.it/services/musport/v1/csv "collegamento al dataset in formato csv") (con integrazioni fornite dai referenti della provincia)


### requisiti
Java 8 + maven

### installazione
`> mvn validate clean package`

### esecuzione
`> java -Dfile.encoding=UTF-8 -jar target/rdfAltoAdige-0.0.1-jar-with-dependencies.jar <output folder>`


