package it.beniculturali.dati.od2lod.rdfRegioni.veneto;

import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;

public class ServiceReader implements DocumentReader {
  private DocumentBuilder documentBuilder;
  private XPath xPath;
  String contentUri;
  private int offset = 0, count = 0;
  static int maxTry = 8, tryAfter = 60; // sec

  public static Document readDocument(String request, DocumentBuilder documentBuilder) throws Exception {
    int tryCount = maxTry;
    for (;;) { //System.out.println("GET " + request);
      try {
        URL url = new URL(request);
        URLConnection connection = url.openConnection();
        connection.setConnectTimeout(tryAfter * 1000);
        connection.setReadTimeout(tryAfter * 1000);
        InputStream xmlInputStream = connection.getInputStream();
        Document document = documentBuilder.parse(xmlInputStream);
        xmlInputStream.close();
        return document;
      } catch (Exception e) {
        System.err.println("ERROR - " + e.toString() + " @try #" + (maxTry - tryCount + 1) + " reading " + request);
        if (--tryCount == 0) {
          throw e;
        }
        Thread.sleep(tryAfter * 1000);
      }
    }
  }

  private Document readDocument(String request) throws Exception {
    return readDocument(request, documentBuilder);
  }

  public ServiceReader(String queryUri, String dataUri, String countPath) throws Exception {
    documentBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
    xPath = XPathFactory.newInstance().newXPath();
    Document doc = readDocument(queryUri);
    count = Integer.parseInt((String) xPath.evaluate(countPath, doc, XPathConstants.STRING));
    System.out.println("STATUS - got " + count + " cards reading @" + queryUri);
    for (int lastPos = 0;;) {
      int pos = dataUri.indexOf("$(/", lastPos);
      if (pos < 0) break;
      int end = dataUri.indexOf(')', pos);
      String value = (String) xPath.evaluate(dataUri.substring(pos + 2, end), doc, XPathConstants.STRING);
      dataUri = dataUri.substring(0, pos) + value + dataUri.substring(end + 1);
      lastPos = pos + value.length();
    }
    contentUri = dataUri;
  }

  public Document next() throws Exception {
    if (offset == count) return null;
    return readDocument(contentUri.replaceAll("\\$\\(offset\\)", "" + offset++));
  }

  public void close() {
  }
}
