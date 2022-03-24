@rem call java -Dfile.encoding=UTF-8 -jar target/rdfAltoAdige-0.0.1-jar-with-dependencies.jar ./results %* 2>&1
@rem to avoid mvn package in test
@call java -Dfile.encoding=UTF-8 -cp target/classes;target/rdfAltoAdige-0.0.1-jar-with-dependencies.jar it.beniculturali.dati.od2lod.rdfRegioni.bolzano.RdfAltoAdige ./results %* 2>&1