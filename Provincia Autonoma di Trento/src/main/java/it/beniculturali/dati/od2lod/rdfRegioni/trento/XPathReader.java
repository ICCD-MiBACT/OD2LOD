package it.beniculturali.dati.od2lod.rdfRegioni.trento;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class XPathReader {
  private NodeList nodeList;
  private DocumentBuilder documentBuilder;

  XPathReader(String url, String xPath) throws IOException, ParserConfigurationException, SAXException, XPathExpressionException {
    this(url, xPath, 0);
  }

  XPathReader(String url, String xPath, int timeout) throws IOException, ParserConfigurationException, SAXException, XPathExpressionException {
    documentBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
    URL targetURL = new URL(url);
    URLConnection connection;
    if (timeout > 0 && targetURL.getProtocol().toLowerCase().startsWith("http")) {
      connection = (HttpURLConnection) targetURL.openConnection();
      connection.setConnectTimeout(timeout * 1000);
    } else
      connection = targetURL.openConnection();
    InputStream xmlInputStream = connection.getInputStream();
    Document document = documentBuilder.parse(xmlInputStream);
    xmlInputStream.close();
    nodeList = (NodeList) XPathFactory.newInstance().newXPath().evaluate(xPath, document, XPathConstants.NODESET);
    System.out.println("got " + nodeList.getLength() + " nodes with path " + xPath);
  }

  private int offset = 0;

  Node next() throws IOException {
    if (nodeList.getLength() - offset <= 0) return null;
    return nodeList.item(offset++);
  }

  void close() throws IOException {
  }
}