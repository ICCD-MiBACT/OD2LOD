package it.beniculturali.dati.od2lod.rdfRegioni;

import java.io.File;
import java.io.FileInputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class ListOfCardReader {
  private DocumentBuilder documentBuilder;
  private XPath xPath;
  File files[];
  NodeList nodes;
  String nodePath;
  int fileIndex = 0, nodeIndex = 0;

  NodeList loadNodes() throws SAXException, IOException, XPathExpressionException {
    if (files.length <= fileIndex) return null;
    System.out.println("STATUS - reading " + files[fileIndex]);
    InputStream is = new FileInputStream(files[fileIndex++]);
    Document document = documentBuilder.parse(is);
    is.close();
    nodeIndex = 0;
    return (NodeList) xPath.evaluate("/*/*", document, XPathConstants.NODESET);
  }

  ListOfCardReader(String folder, String nodePath) throws ParserConfigurationException, XPathExpressionException, SAXException, IOException {
    documentBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
    xPath = XPathFactory.newInstance().newXPath();
    this.nodePath = nodePath;
    File f = new File(folder);
    FilenameFilter filter = new FilenameFilter() {
      public boolean accept(File f, String name) {
        return name.endsWith(".xml");
      }
    };
    files = f.listFiles(filter);
    nodes = loadNodes();
  }

  Element next() throws IOException, XPathExpressionException, SAXException {
    if (nodes.getLength() <= nodeIndex) {
      nodes = loadNodes();
      if (nodes == null) return null;
    }
    return (Element) nodes.item(nodeIndex++);
  }

  void close() throws IOException {
  }
}
