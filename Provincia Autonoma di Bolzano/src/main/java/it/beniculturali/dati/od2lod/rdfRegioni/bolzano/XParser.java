package it.beniculturali.dati.od2lod.rdfRegioni.bolzano;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.transform.Result;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.xml.sax.Attributes;
import org.xml.sax.ErrorHandler;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;

public class XParser extends DefaultHandler implements ErrorHandler {
  Transformer transformer;
  int tCount = 0;
  int depth = 0;
  int startDepth; // nesting
  boolean writeChars = false;
  Node node;
  Document document = null;
  XMLReader reader;
  String parseElementName;
  XWriter writer;

  public XParser(/*XMLReader xmlReader,*/InputStream is, String elementName, XWriter writer, String xslt, Map<String, String> transformerParams)
      throws SAXException, ParserConfigurationException, TransformerConfigurationException {
    SAXParserFactory saxParserFactory = SAXParserFactory.newInstance();
    saxParserFactory.setValidating(false);
    this.reader = saxParserFactory.newSAXParser().getXMLReader();
    //this.reader = xmlReader;
    this.writer = writer;
    this.reader.setContentHandler(this);
    this.reader.setErrorHandler(this);
    this.parseElementName = elementName;

    document = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
    TransformerFactory transformerFactory = TransformerFactory.newInstance();
    String xsltUrl = new Resource().getUrl(xslt).toString();
    transformer = transformerFactory.newTransformer(new StreamSource(xsltUrl));

    if (transformerParams != null) {
      Object paramNames[] = transformerParams.keySet().toArray();
      for (int j = 0; j < paramNames.length; j++) {
        transformer.setParameter((String) paramNames[j], transformerParams.get(paramNames[j]));
      }
    }
    node = document;
  }

  public void startDocument() throws SAXException {
  }

  public void endDocument() throws SAXException {
  }

  String startName(String localName, String qName) {
    if (localName != null && localName.length() > 0) return localName;
    return qName;
  }

  boolean testWriteNode(String name) {
    return (parseElementName != null && name.compareTo(parseElementName) == 0);
  }

  public void startElement(String namespaceURI, String localName, String qName, Attributes atts) throws SAXException {
    String name = startName(localName, qName);
    depth++;
    boolean isStart = writeChars == false;
    boolean isWriteNode = testWriteNode(name);
    if (isStart && isWriteNode) startDepth = depth;
    if (isWriteNode) writeChars = true;
    isStart = isStart && writeChars == true;
    if (writeChars) {
      Element element = document.createElementNS(namespaceURI, qName);
      for (int j = 0; j < atts.getLength(); j++) {
        String qname = atts.getQName(j);
        try {
          element.setAttributeNS(atts.getURI(j), qname, atts.getValue(j));
        } catch (DOMException e) {
          String uri = atts.getURI(j);
          if (uri == null || uri.isEmpty()) {
            if (qname.startsWith("xml:"))
              uri = "http://www.w3.org/XML/1998/namespace";
            else if (qname.startsWith("xmlns"))
              uri = "http://www.w3.org/2000/xmlns/";
            else
              throw (e);
            element.setAttributeNS(uri, qname, atts.getValue(j));
          }
        }
      }
      node.appendChild(element);
      node = element;
    }
  }

  public void characters(char[] ch, int start, int length) throws SAXException {
    if (writeChars) node.appendChild(document.createTextNode(new String(ch, start, length)));
  }

  public void endElement(String namespaceURI, String localName, String qName) throws SAXException {
    String name = startName(localName, qName);
    if (writeChars) {
      node = node.getParentNode();
    } //System.out.println("name:"+name + " depth:" + depth);
    if (depth == startDepth && testWriteNode(name)) {
      try {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Result result = new StreamResult(baos);
        transformer.transform(new DOMSource(document), result);
        writer.write(baos, document);
        tCount++;
      } catch (TransformerException e) {
        e.printStackTrace();
        throw new SAXException(e);
      }
      document.removeChild(document.getDocumentElement());
      writeChars = false;
    }
    depth--;
  }

  public void warning(SAXParseException spe) throws SAXException {/*spe.printStackTrace();*/
  }

  public void error(SAXParseException spe) throws SAXException {/*spe.printStackTrace();*/
  }

  public void fatalError(SAXParseException spe) throws SAXException {/*spe.printStackTrace();*/
  }

  public void parse(InputStream is, XWriter writer) throws Exception {//System.out.println("parsing...");
    this.writer = writer;
    try {
      reader.parse(new InputSource(new BufferedInputStream(is)));
    } catch (Exception exception) {
      exception.printStackTrace();
      throw (exception);
    }
  }

}
