package it.beniculturali.dati.od2lod.rdfRegioni.veneto;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.SourceLocator;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.SAXException;

import it.cnr.istc.stlab.arco.Converter;
import net.sf.saxon.s9api.MessageListener;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.XsltTransformer;

class VenetoConverter extends Converter {
  DocumentBuilder builder = null;
  Transformer transformer = null;

  StreamSource setStylesheetVersionAttribute(Path path) throws ParserConfigurationException, TransformerFactoryConfigurationError, IOException, SAXException,
      TransformerException {
    if (builder == null) builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
    if (transformer == null) transformer = TransformerFactory.newInstance().newTransformer();
    InputStream is = Files.newInputStream(path);
    Document xslt = builder.parse(is);
    is.close();
    Element stylesheet = xslt.getDocumentElement();
    stylesheet.setAttribute("version", "1.0"); //System.out.println("@version "+stylesheet.getAttribute("version")+" @"+path.getFileName());
    ByteArrayOutputStream os = new ByteArrayOutputStream();
    transformer.transform(new DOMSource(xslt), new StreamResult(os));
    return new StreamSource(new ByteArrayInputStream(os.toByteArray()));
  }

  @Override
  // xslt version 1.0 to allow partial import of non schema compliant data
  public StreamSource xslt2source(Path path) throws Exception {//return new StreamSource(Files.newInputStream(path));
    // preserve line number in error messages //return setStylesheetVersionAttribute(path);
    byte[] b = Files.readAllBytes(path);
    String s = new String(b, StandardCharsets.UTF_8.toString());
    int start = s.indexOf("<xsl:stylesheet");
    int stop = s.indexOf(">", start), pos = s.indexOf("version", start);
    if (pos < stop) {
      start = s.indexOf('"', pos); // avoid single quotes in attributes please
      int end = s.indexOf('"', start + 1);
      if (start < stop && end < stop) {
        if (b[start + 1] == '2')
          b[start + 1] = '1';
        else
          System.out.println("xslt version 1 @" + path.getFileName());
      } else
        System.out.println("xslt version not found @" + path.getFileName());
    }
    return new StreamSource(new ByteArrayInputStream(b));
  }

  @Override
  public void prepareTransformer(XsltTransformer trans, String name) {
    final String xsl = name;
    trans.setMessageListener(new MessageListener() {
      public void message(XdmNode arg0, boolean arg1, SourceLocator arg2) {
        System.out.println("message: \"" + arg0.getStringValue() + "\" @" + xsl);
      }
    });
  }

  @Override
  public void customizeXsltProcessor(Processor proc) {
    proc.registerExtensionFunction(CatalogueRecordIdentifierToCulturalProperty.getInstance());
  };
}
