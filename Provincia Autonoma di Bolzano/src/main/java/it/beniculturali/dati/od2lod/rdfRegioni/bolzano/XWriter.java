package it.beniculturali.dati.od2lod.rdfRegioni.bolzano;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;

public class XWriter {
  List<ByteArrayOutputStream> list;
  List<byte[]> source;
  Transformer nullTransformer;

  XWriter(List<ByteArrayOutputStream> list, List<byte[]> source) throws TransformerConfigurationException, TransformerFactoryConfigurationError {
    nullTransformer = TransformerFactory.newInstance().newTransformer();
    this.list = list;
    this.source = source;
  }

  byte[] doc2bytes(Document d) throws TransformerException {
    ByteArrayOutputStream os = new ByteArrayOutputStream();
    nullTransformer.transform(new DOMSource(d), new StreamResult(os));
    return os.toByteArray();
  }

  public void write(ByteArrayOutputStream baos, Document sourceDocument) throws TransformerException {//try {System.out.println(new String(baos.toByteArray(),"utf-8"));} catch (Exception e) {e.printStackTrace();}
    source.add(doc2bytes(sourceDocument));
    list.add(baos);
  }
}
