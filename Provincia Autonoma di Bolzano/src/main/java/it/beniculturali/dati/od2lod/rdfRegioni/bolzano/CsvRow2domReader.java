package it.beniculturali.dati.od2lod.rdfRegioni.bolzano;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.stream.Collectors;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.opencsv.CSVReader;
import com.opencsv.CSVReaderBuilder;
import com.opencsv.RFC4180ParserBuilder;

public class CsvRow2domReader {
  private CSVReader reader;
  private Set<String> splitFields = null, filter = null;
  private DocumentBuilder documentBuilder;
  private Map<String, Integer> cell2index = new HashMap<String, Integer>();
  private String splitter = null, fieldNames[], cellFilter = null;

  CsvRow2domReader(String url, String splitter, String splitFields) throws IOException, ParserConfigurationException {
    this(url, splitter, splitFields, false, 0);
  }

  CsvRow2domReader(String url, String splitter, String splitFields, boolean preload, int timeout) throws IOException, ParserConfigurationException {
    this(url, splitter, splitFields, false, timeout, true);
  }

  CsvRow2domReader(String url, String splitter, String splitFields, boolean preload, int timeout, boolean RFC4180Parser) throws IOException,
      ParserConfigurationException {
    this(url, splitter, splitFields, false, timeout, true, null, null);
  }

  CsvRow2domReader(String url, String splitter, String splitFields, boolean preload, int timeout, boolean RFC4180Parser, Set<String> filter, String cellFilter)
      throws IOException, ParserConfigurationException {
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
      System.out.println("splitter is '" + splitter + "'");
    }
    //reader = new CSVReaderBuilder(new BufferedReader(new InputStreamReader(new URL(url).openConnection().getInputStream(), StandardCharsets.UTF_8))).withCSVParser(new RFC4180ParserBuilder().build()).build();
    URL targetURL = new URL(url);
    URLConnection connection;
    if (timeout > 0 && targetURL.getProtocol().toLowerCase().startsWith("http")) {
      connection = (HttpURLConnection) targetURL.openConnection();
      connection.setConnectTimeout(timeout * 1000);
    } else
      connection = targetURL.openConnection();
    BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8));
    if (preload) { // avoid read timeout issues
      String content = br.lines().collect(Collectors.joining("\n"));
      br.close();
      br = new BufferedReader(new StringReader(content));
    }
    if (!RFC4180Parser)
      reader = new CSVReaderBuilder(br).build();
    else
      reader = new CSVReaderBuilder(br).withCSVParser(new RFC4180ParserBuilder().build()).build();
    fieldNames = reader.readNext();
    for (int j = 0; j < fieldNames.length; j++)
      cell2index.put(fieldNames[j], new Integer(j));
  }

  // https://www.xmltutorial.info/xml/how-to-remove-invalid-characters-from-xml/
  private String stripChar(String s, String replacer) { // #x9 | #xA | #xD | [#x20-#xD7FF] | [#xE000-#xFFFD] | [#x10000-#x10FFFF]
    String xml10pattern = "[^" + "\u0009\r\n" + "\u0020-\uD7FF" + "\uE000-\uFFFD" + "\ud800\udc00-\udbff\udfff£" + "]";
    return s.replaceAll(xml10pattern, replacer);
  }

  static String stripReplacer = "";
  static boolean leaveEmpty = false, trimFields = true;

  private void addCell(Element row, String name, String value) {
    addCell(row, name, value, leaveEmpty);
  }

  private void addCell(Element row, String name, String value, boolean leaveEmpty) {
    if (stripReplacer != null) value = stripChar(value, stripReplacer);
    if (trimFields) value = value.trim();
    if (!leaveEmpty && value.length() == 0) return;
    Element cell = row.getOwnerDocument().createElement("cell");
    cell.setAttribute("name", name);
    // vedi il commento precedente per splitter
    cell.appendChild(row.getOwnerDocument().createTextNode(value.replaceAll("\\\\,", ","))); // TODO andrebbe letto da properties
    row.appendChild(cell);
  }

  private int lines = 1;

  int line() {
    return lines;
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
        addCell(row, fieldNames[j], fieldValues[j]);
    }
    return document;
  }

  String cellValue(String[] values, String cell) {
    return values[cell2index.get(cell)];
  }

  Document next() throws IOException {
    for (;;) {
      String[] fieldValues = reader.readNext();
      if (fieldValues == null) return null;
      lines++;
      if (fieldValues.length != fieldNames.length)
        System.err.println("field count mismatch at line " + lines + " " + fieldValues.length + "!=" + fieldNames.length + " (line starts with '"
            + fieldValues[0] + "')");
      if (filter == null || filter.contains(cellValue(fieldValues, cellFilter).trim().toLowerCase())) return row2document(fieldValues);
    }
  }

  void close() throws IOException {
    if (reader != null) reader.close();
  }
}