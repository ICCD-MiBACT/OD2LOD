package it.beniculturali.dati.od2lod.rdfRegioni;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.HashSet;
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
  private Set<String> splitFields = null;
  private DocumentBuilder documentBuilder;
  private String splitter = null, fieldNames[];

  CsvRow2domReader(String url, String splitter, String splitFields) throws IOException, ParserConfigurationException {
    this(url, splitter, splitFields, false, 0);
  }

  CsvRow2domReader(String url, String splitter, String splitFields, boolean preload, int timeout) throws IOException, ParserConfigurationException {
    documentBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
    if (splitter != null) {
      System.out.println("splitter is '" + splitter + "'");
      this.splitter = splitter.replaceAll("\\|", Matcher.quoteReplacement("\\|"));
      if (splitFields != null) {
        this.splitFields = new HashSet<String>(Arrays.asList(splitFields.split(",")));
        System.out.println(" " + this.splitFields.size() + " fields to split " + this.splitFields);
      }
    }
    //reader = new CSVReaderBuilder(new BufferedReader(new InputStreamReader(new URL(url).openConnection().getInputStream(), StandardCharsets.UTF_8))).withCSVParser(new RFC4180ParserBuilder().build()).build();
    URL targetURL = new URL(url);
    URLConnection connection;
    if (timeout > 0 && targetURL.getProtocol().compareToIgnoreCase("file") != 0) {
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
    reader = new CSVReaderBuilder(br).withCSVParser(new RFC4180ParserBuilder().build()).build();
    fieldNames = reader.readNext();
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
    cell.appendChild(row.getOwnerDocument().createTextNode(value));
    row.appendChild(cell);
  }

  private int lines = 1;
  private Set<String> multi = new HashSet<String>();

  Document next() throws IOException {
    String[] fieldValues = reader.readNext();
    if (fieldValues == null) return null;
    lines++;
    if (fieldValues.length != fieldNames.length)
      System.err.println("field count mismatch at line " + lines + " " + fieldValues.length + "!=" + fieldNames.length + " (line starts with '"
          + fieldValues[0] + "')");
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

  void close() throws IOException {
    if (reader != null) reader.close();
  }
}