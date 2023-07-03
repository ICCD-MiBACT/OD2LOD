package it.beniculturali.dati.od2lod.rdfRegioni.bolzano;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.stream.Collectors;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.opencsv.CSVParser;
import com.opencsv.CSVParserBuilder;
import com.opencsv.CSVReader;
import com.opencsv.CSVReaderBuilder;
import com.opencsv.RFC4180ParserBuilder;

public class CsvRow2domReader {
  private CSVReader reader;
  private Set<String> splitFields = null, filter = null;
  private DocumentBuilder documentBuilder;
  private Map<String, Integer> cell2index = new HashMap<String, Integer>();
  private List<Map<String, String>> fieldmap = new ArrayList<Map<String, String>>();
  private String splitter = null, fieldNames[], cellFilter = null, separator = null, charset = null;
  private String[] uris = null;
  static boolean default_RFC4180Parser = true, default_preload = true;
  private boolean RFC4180Parser = default_RFC4180Parser, preload = default_preload;
  static int default_timeout = 30;
  private int timeout = default_timeout, uriIndex = 0;

  private void loadURI(int index) throws IOException {
    String uri = uris[index];
    System.out.println("STATUS - reading @" + uri);
    URL targetURL = new URL(uri);
    URLConnection connection;
    if (timeout > 0 && targetURL.getProtocol().toLowerCase().startsWith("http")) {
      connection = (HttpURLConnection) targetURL.openConnection();
      connection.setConnectTimeout(timeout * 1000);
    } else
      connection = targetURL.openConnection();
    charset = charset != null ? charset.trim() : StandardCharsets.UTF_8.name();//System.out.println("charset:"+charset);
    BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream(), charset));
    if (preload) { // avoid read timeout issues
      String content = br.lines().collect(Collectors.joining("\n"));
      br.close();
      br = new BufferedReader(new StringReader(content));
    }
    char separ = separator != null ? separator.trim().charAt(0) : ',';
    System.out.println("STATUS - charset: '" + charset + "', separator '" + separ + "'");
    if (!RFC4180Parser)
      reader = new CSVReaderBuilder(br).withCSVParser(new CSVParserBuilder().withSeparator(separ).build()).build();
    else
      reader = new CSVReaderBuilder(br).withCSVParser(new RFC4180ParserBuilder().withSeparator(separ).build()).build();
    fieldNames = reader.readNext();
    if (fieldmap.size() > index) {
      Map<String, String> fm = fieldmap.get(index);
      if (fm != null) for (int j = 0; j < fieldNames.length; j++) {
        String f = fm.get(fieldNames[j]);
        if (f != null) fieldNames[j] = f;
      }
    }
    for (int j = 0; j < fieldNames.length; j++)
      cell2index.put(fieldNames[j], new Integer(j));
  }

  //CsvRow2domReader(String url, String splitter, String splitFields) throws IOException, ParserConfigurationException {this(url, splitter, splitFields, false, 0);}
  //CsvRow2domReader(String url, String splitter, String splitFields, boolean preload, int timeout) throws IOException, ParserConfigurationException {this(url, splitter, splitFields, false, timeout, true);}
  //CsvRow2domReader(String url, String splitter, String splitFields, boolean preload, int timeout, boolean RFC4180Parser) throws IOException, ParserConfigurationException {this(url, splitter, splitFields, false, timeout, true, null, null);}
  //CsvRow2domReader(String url, String splitter, String splitFields, boolean preload, int timeout, boolean RFC4180Parser, Set<String>filter, String cellFilter) throws IOException, ParserConfigurationException {this(url, splitter, splitFields, false, timeout, true, filter, cellFilter, null, null);}
  //CsvRow2domReader(String url, String splitter, String splitFields, boolean preload, int timeout, boolean RFC4180Parser, Set<String>filter, String cellFilter, String charset, String separator) throws IOException, ParserConfigurationException{
  CsvRow2domReader(String url) throws IOException, ParserConfigurationException {
    this(url, default_preload, default_timeout, default_RFC4180Parser, null, null, null, null);
  }

  CsvRow2domReader(String url, boolean preload, int timeout, boolean rfc4180Parser, Set<String> filter, String cellFilter, Properties p, String pp)
      throws IOException, ParserConfigurationException {
    String splitter = null, splitFields = null;
    if (p != null) {
      splitter = p.getProperty(pp + ".splitter");
      splitFields = p.getProperty(pp + ".split");
      charset = p.getProperty(pp + ".charset");
      separator = p.getProperty(pp + ".separator");
    }
    RFC4180Parser = rfc4180Parser;
    this.timeout = timeout;
    this.preload = preload;
    this.filter = filter;
    this.cellFilter = cellFilter;
    documentBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
    if (splitter != null) { //System.out.println("splitter is '" + splitter + "'");
      //this.splitter = splitter.replaceAll("\\|", Matcher.quoteReplacement("\\|")); 
      if (splitFields != null) {
        this.splitFields = new HashSet<String>(Arrays.asList(splitFields.split(",")));
        System.out.println(" " + this.splitFields.size() + " fields to split " + this.splitFields);
      }
      // nella cella le sequenze "\," vanno sostituite con "," mentre virgole non precedute da "\" vanno usate come splitter
      this.splitter = "(?<!\\\\),"; // TODO andrebbe letto da properties
      System.out.println("INFO - splitter is '" + this.splitter + "'");
    }
    //reader = new CSVReaderBuilder(new BufferedReader(new InputStreamReader(new URL(url).openConnection().getInputStream(), StandardCharsets.UTF_8))).withCSVParser(new RFC4180ParserBuilder().build()).build();
    uris = url.split(",");
    fieldmap = new ArrayList<Map<String, String>>();
    String fms = p != null ? p.getProperty(pp + ".fieldmap") : null;
    if (fms != null) {
      String[] fma = fms.split(",", -1);
      for (int j = 0; j < uris.length; j++)
        fieldmap.add(string2map(j < fma.length ? fma[j] : null));
    }
    loadURI(0);/*
      int urlIndex = 0;
      String uri = uris[urlIndex];
      URL targetURL = new URL(uri); URLConnection connection;
      if (timeout>0 && targetURL.getProtocol().toLowerCase().startsWith("http")) {
       connection = (HttpURLConnection) targetURL.openConnection();
       connection.setConnectTimeout(timeout*1000);
      }
      else connection = targetURL.openConnection();
      charset = charset!=null?charset.trim():StandardCharsets.UTF_8.name();//System.out.println("charset:"+charset);
      BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream(),charset)); 
      if (preload) { // avoid read timeout issues
       String content = br.lines().collect(Collectors.joining("\n")); br.close();
       br = new BufferedReader(new StringReader(content));
      }
      char separ = separator!=null?separator.trim().charAt(0):',';
      System.out.println("STATUS - charset: '" + charset + "', separator '" + separ + "'");
      if (!RFC4180Parser) reader = new CSVReaderBuilder(br).withCSVParser(new CSVParserBuilder().withSeparator(separ).build()).build();
      else reader = new CSVReaderBuilder(br).withCSVParser(new RFC4180ParserBuilder().withSeparator(separ).build()).build();
      fieldNames = reader.readNext();
      if (fieldmap.size()>urlIndex) { Map<String,String>fm = fieldmap.get(urlIndex);
       if (fm!=null) for (int j=0;j<fieldNames.length;j++) {String f = fm.get(fieldNames[j]); if (f!=null) fieldNames[j] = f;}
      }
      for (int j=0;j<fieldNames.length;j++)cell2index.put(fieldNames[j], new Integer(j));
     */
  }

  private Map<String, String> string2map(String s) {
    if (s == null || s.trim().length() == 0) return null;
    Map<String, String> r = new HashMap<String, String>();
    String[] a = s.split(";");
    for (String t : a) {
      String[] f = t.split("\\|");
      r.put(f[0], f[1]);
    }
    return r;
  }

  // https://www.xmltutorial.info/xml/how-to-remove-invalid-characters-from-xml/
  private String stripChar(String s, String replacer) { // #x9 | #xA | #xD | [#x20-#xD7FF] | [#xE000-#xFFFD] | [#x10000-#x10FFFF]
    String xml10pattern = "[^" + "\u0009\r\n" + "\u0020-\uD7FF" + "\uE000-\uFFFD" + "\ud800\udc00-\udbff\udfff£" + "]";
    return s.replaceAll(xml10pattern, replacer);
  }

  static String stripReplacer = "";
  static boolean leaveEmpty = false, trimFields = true;

  //String massage(String name, String value, String[]values) {
  String massage(String name, String value, Element row) {
    if (name.compareTo("RI_it") == 0) { // più istanze probabilmente in relazione al numero di immagini che
      // non vengono trattate come individui nella trasformazione, elimina duplicati e dati non significativi
      String[] a = value.split(splitter);
      Set<String> r = new HashSet<String>();
      int count = 0;
      for (String v : a) {
        String t = v.replaceAll("[ -]+", "");
        if (t.length() > 0) {
          count++;
          r.add(v.replaceAll("\\\\,", ",").replaceAll("\\\\n", "\n"));
        }
      }
      String joiner = "; ";
      String result = String.join(joiner, r);
      //if (values!=null && result.length()>0 && count<a.length) { // aggiunge MUS se istanze prive di valore esplicito e non
      // String mus = cellValue(values, "MUS"); if (mus!=null) { mus = mus.trim(); if (mus.length()>0) result = mus + "; " + result; }
      //}
      if (result.length() > 0 && count < a.length) cell2elem(row, "XRI", joiner);
      return result;
    }
    // vedi il commento precedente per splitter
    return value.replaceAll("\\\\,", ",").replaceAll("\\\\n", "\n"); // TODO andrebbe letto da properties
  }

  private void cell2elem(Element row, String name, String value) {
    Element cell = row.getOwnerDocument().createElement("cell");
    cell.setAttribute("name", name);
    cell.appendChild(row.getOwnerDocument().createTextNode(value));
    row.appendChild(cell);
  }

  private void addCell(Element row, String name, String value) {
    addCell(row, name, value, leaveEmpty);
  }

  //private void addCell(Element row, String name, String value, String[]values) { addCell(row, name, value, leaveEmpty, values); }
  private void addCell(Element row, String name, String value, boolean leaveEmpty) {
    addCell(row, name, value, leaveEmpty, null);
  }

  private void addCell(Element row, String name, String value, boolean leaveEmpty, String[] values) {
    if (stripReplacer != null) value = stripChar(value, stripReplacer);
    if (trimFields) value = value.trim();
    value = massage(name, value, row);//massage(name, value, values);
    if (!leaveEmpty && value.length() == 0) return;
    cell2elem(row, name, value);
  }

  private int lines = 1, skip = 0;

  int line() {
    return lines;
  }

  int skip() {
    return skip;
  }

  private Set<String> multi = new HashSet<String>();

  Document row2document(String[] fieldValues) {
    Document document = documentBuilder.newDocument();
    Element row = document.createElement("row");
    document.appendChild(row);
    for (int j = 0; j < fieldValues.length && j < fieldNames.length; j++) {
      if (splitter != null && (splitFields == null || splitFields.contains(fieldNames[j])) /*&& fieldValues[j].indexOf(splitter)>=0*/) {
        String[] values = fieldValues[j].split(splitter, -2);
        if (values.length > 1 && !multi.contains(fieldNames[j])) {
          System.out.println(fieldNames[j] + " is multiple '" + fieldValues[j] + "'");
          multi.add(fieldNames[j]);
        }
        for (String value : values)
          addCell(row, fieldNames[j], value, values.length > 1);
      } else
        addCell(row, fieldNames[j], fieldValues[j]);//addCell(row, fieldNames[j], fieldValues[j], fieldValues);
    }
    return document;
  }

  String cellValue(String[] values, String cell) {
    return values[cell2index.get(cell)];
  }

  Document next() throws IOException {
    for (;;) {
      String[] fieldValues = reader.readNext();
      if (fieldValues == null) {
        if (++uriIndex == uris.length) return null;
        close();
        loadURI(uriIndex);
        return next();
      }
      lines++;
      if (fieldValues.length != fieldNames.length)
        System.err.println("field count mismatch at line " + lines + " " + fieldValues.length + "!=" + fieldNames.length + " (line starts with '"
            + fieldValues[0] + "')");
      //if (filter==null||filter.contains(cellValue(fieldValues,cellFilter).trim().toLowerCase()))
      if (filter == null || !filter.contains(cellValue(fieldValues, cellFilter).trim().toLowerCase())) return row2document(fieldValues);
      skip++;
    }
  }

  void close() throws IOException {
    if (reader == null) return;
    reader.close();
    reader = null;
  }
}