#!/bin/bash

XML_DIR="./xml"
CSV_DIR="./csv"
ENDPOINT="https://dati.beniculturali.it/sparql"

count_items_query=$(cat <<-END
query=select (count(distinct ?s) as ?count) {
  graph <https://w3id.org/arco/sardegna/data> {
    VALUES ?class {
      <https://w3id.org/arco/ontology/arco/ImmovableCulturalProperty> 
      <https://w3id.org/arco/ontology/arco/MovableCulturalProperty>
    }
    ?s a ?class .
  }
}
END
)

echo "lines in original CSV files are "$(find $CSV_DIR -type f -exec cat {} + | wc -l)

echo "XML files obtained after conversion are: "$(find $XML_DIR -type f | wc -l)

echo "Distinct item loaded on virtuoso: "$(curl -X POST --data-urlencode "$count_items_query" -s $ENDPOINT'?default-graph-uri=&format=application%2Fsparql-results%2Bjson&timeout=0&debug=on&run=+Run+Query+' | jq  '.results .bindings [0] .count .value')
