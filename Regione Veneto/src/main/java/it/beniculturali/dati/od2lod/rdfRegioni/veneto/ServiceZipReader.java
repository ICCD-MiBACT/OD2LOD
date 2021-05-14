package it.beniculturali.dati.od2lod.rdfRegioni.veneto;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.FileSystem;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactoryConfigurationError;

import org.w3c.dom.Document;

public class ServiceZipReader extends Zip implements DocumentReader  {
 private FileSystem fs;
 private int index = 0;
 private DocumentBuilder builder = null;
 List<Path>files = new ArrayList<Path>();
 ServiceZipReader(File z) throws IOException, ParserConfigurationException, TransformerConfigurationException, TransformerFactoryConfigurationError{
  builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
  fs = open(z);
  files = list(fs); System.out.println("zip folder " + z + " has " + files.size() + " files");
 }
 public Document next() throws Exception {
  if (index>=files.size()) return null;
  InputStream is = Files.newInputStream(files.get(index++));
  Document result = builder.parse(is); is.close();
  return result;
 }
 public void close() {}
}