package it.beniculturali.dati.od2lod.rdfRegioni.bolzano;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import java.util.stream.Collectors;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.xml.sax.SAXException;

public class XPager implements RowReader {
  private DocumentBuilder documentBuilder;
  private String[] uris = null;
  static int default_timeout = 30;
  private int timeout = default_timeout, uriIndex = 0;
  List<ByteArrayOutputStream> content = null;
  List<byte[]> source = null;
  int contentIndex = 0;
  XParser xParser;
  String sourceXslt;
  String sourceElement;
  String urlparamname;
  String urlparamvalue = null;
  //int sourcePage, sourceOffset=0;
  int sourceOffset = 0;
  String sourcePage;
  boolean paging = false;

  //SAXParserFactory saxParserFactory;

  XPager() throws ParserConfigurationException, SAXException {
    documentBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
    /*saxParserFactory = SAXParserFactory.newInstance();
    saxParserFactory.setValidating(false);*/

  }

  private void loadURI(int index) throws IOException {
    String uri = uris[index];
    if (uri.endsWith("=")) {
      if (!paging) sourceOffset = 0;
      if (sourcePage.contains(",")) {
        uri += sourcePage.split(",")[sourceOffset];
        sourceOffset++;
      } else {
        uri += "" + sourceOffset;
        sourceOffset += Integer.parseInt(sourcePage);
      }
    }
    System.out.println("STATUS - reading @" + uri);
    InputStream is = null;
    int maxTry = 3, tryWait = 15, timeout = 30;
    for (int tryCount = 1;; tryCount++) {
      try {
        URL targetURL = new URL(uri);
        URLConnection connection;
        if (timeout > 0 && targetURL.getProtocol().toLowerCase().startsWith("http")) {
          connection = (HttpURLConnection) targetURL.openConnection();
          connection.setConnectTimeout(timeout * 1000);
        } else
          connection = targetURL.openConnection();
        is = connection.getInputStream();
        break;
      } catch (Exception e) {
        if (tryCount == maxTry) {
          throw new IOException(e);
        }
        System.err.println("ERROR - failure @try " + tryCount + "/" + maxTry + " " + e);
        e.printStackTrace();
        try {
          Thread.sleep(tryWait * 1000);
        } catch (Exception s) {
          throw new IOException(s);
        }
      }
    }
    contentIndex = 0;
    content = new ArrayList<ByteArrayOutputStream>();
    source = new ArrayList<byte[]>();
    try {
      XWriter writer = new XWriter(content, source);
      xParser = new XParser(/*saxParserFactory.newSAXParser().getXMLReader(),*/is, sourceElement, writer, sourceXslt,
          urlparamvalue != null ? new HashMap<String, String>() {
            {
              put(urlparamname, urlparamvalue);
            }
          } : null);
      xParser.parse(is, writer);
      paging = uris[index].endsWith("=")
          && ((!sourcePage.contains(",") && (xParser.tCount > 0)) || (sourcePage.contains(",") && sourceOffset < sourcePage.split(",").length));

    } catch (Exception e) {
      throw new IOException(e);
    } finally {
      is.close();
    }
  }

  String url2string(String url) throws IOException {
    URLConnection connection = new URL(url).openConnection();
    BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8.name()));
    String content = br.lines().collect(Collectors.joining("\n"));
    br.close();
    return content;
  }

  public RowReader get(String url, boolean preload, int timeout, boolean rfc4180Parser, Set<String> filter, String cellFilter, Properties p, String pp)
      throws IOException, ParserConfigurationException {
    uris = url.split(";");
    sourceXslt = p.getProperty(pp + ".source.xslt");
    sourceElement = p.getProperty(pp + ".source.element");
    //sourcePage = Integer.parseInt(p.getProperty(pp + ".source.page"));
    sourcePage = p.getProperty(pp + ".source.page");
    urlparamname = p.getProperty(pp + ".source.xslt.urlparam.name");
    if (urlparamname != null) urlparamvalue = url2string(p.getProperty(pp + ".source.xslt.urlparam.source"));
    loadURI(0);
    return this;
  }

  public Document next() throws IOException {
    return next(null);
  }

  public Document next(List<byte[]> src) throws IOException {
    if (contentIndex == content.size()) {
      if (paging) {
        loadURI(uriIndex);
        return next(src);
      }
      if (++uriIndex == uris.length) return null;
      loadURI(uriIndex);
      return next(src);
    }
    try {
      for (;;) { //System.out.println("content=>\n"+new String(content.get(contentIndex).toByteArray(),"utf-8"));
        byte[] ba = content.get(contentIndex).toByteArray();
        if (src != null) src.add(source.get(contentIndex)); //else System.out.println("src is null");
        contentIndex++;
        lines++;
        if (ba.length > 0) {
          Document document = documentBuilder.parse(new ByteArrayInputStream(ba));
          if (document.hasChildNodes()) {//System.out.println("document has " + document.getChildNodes().getLength() + " child nodes");
            return document;
          }
        }
        skip++;
        if (contentIndex == content.size()) return next(src);
      }
    } catch (SAXException e) {
      throw new IOException(e);
    }
  }

  public void close() throws IOException {
  }

  private int lines = 0, skip = 0;

  public int line() {
    return lines;
  }

  public int rows() {
    return lines;
  }

  public int skip() {
    return skip;
  }

}
