#!/bin/bash

RDF_FILE=$1
RDFIZER_LOCATION=$2
CURRENT_DIR=$(pwd)"/"

cd $RDFIZER_LOCATION
echo $(pwd)

java -Xmx2G -jar target/arco.rdfizer.jar $CURRENT_DIR"xml/" $CURRENT_DIR$RDF_FILE

