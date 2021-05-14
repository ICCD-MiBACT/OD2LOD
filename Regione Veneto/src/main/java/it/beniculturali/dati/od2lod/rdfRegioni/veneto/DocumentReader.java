package it.beniculturali.dati.od2lod.rdfRegioni.veneto;

import org.w3c.dom.Document;

interface DocumentReader {
  public Document next() throws Exception;

  public void close();
}