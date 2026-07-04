package it.beniculturali.dati.od2lod.rdfRegioni.bolzano;

import java.io.IOException;
import java.util.List;
import java.util.Properties;
import java.util.Set;

import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;

public interface RowReader {
  //RowReader get(String url)throws IOException, ParserConfigurationException;
  RowReader get(String url, boolean preload, int timeout, boolean rfc4180Parser, Set<String> filter, String cellFilter, Properties p, String pp)
      throws IOException, ParserConfigurationException;

  Document next(List<byte[]> source) throws IOException;

  Document next() throws IOException;

  void close() throws IOException;

  int skip();

  int line();

  int rows();
}
