package it.beniculturali.dati.od2lod.rdfRegioni.bolzano;

import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.zip.GZIPOutputStream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;
import org.jsoup.Jsoup;
import org.jsoup.select.Elements;
import org.mapdb.DB;
import org.mapdb.DBMaker;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

import it.cnr.istc.stlab.arco.Converter;
import it.cnr.istc.stlab.arco.preprocessing.PreprocessedData;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.Serializer;
import net.sf.saxon.s9api.XdmAtomicValue;
import net.sf.saxon.s9api.XsltCompiler;
import net.sf.saxon.s9api.XsltTransformer;

public class RdfAltoAdige {
  private DocumentBuilder db;
  private Transformer nullTransformer;

  RdfAltoAdige() throws IOException, TransformerConfigurationException, TransformerFactoryConfigurationError, ParserConfigurationException {
    db = DocumentBuilderFactory.newInstance().newDocumentBuilder();
    loadProperties();
    nullTransformer = TransformerFactory.newInstance().newTransformer();
  }

  InputStream ras(String s) {
    return this.getClass().getClassLoader().getResourceAsStream(s);
  }

  Properties properties = new Properties();

  void loadProperties() throws IOException {
    InputStream is = ras("rdfAltoAdige.properties");
    properties.load(is);
    is.close();
  }

  static String safeIriPart(String s, String replacer) {
    String pattern = "[^" + "-A-Za-z0-9\\._~" + "\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF" + "\u10000-\u1FFFD\u20000-\u2FFFD\u30000-\u3FFFD"
        + "\u40000-\u4FFFD\u50000-\u5FFFD\u60000-\u6FFFD" + "\u70000-\u7FFFD\u80000-\u8FFFD\u90000-\u9FFFD" + "\uA0000-\uAFFFD\uB0000-\uBFFFD\uC0000-\uCFFFD"
        + "\uD0000-\uDFFFD\uE1000-\uEFFFD" + "]";
    return s.replaceAll(pattern, replacer);
  }

  static void fatal(String outFolder, Throwable t) throws UnsupportedEncodingException, FileNotFoundException {
    String filename = "" + new Date().getTime() + ".exception";
    System.err.println("ERROR - Exception " + t + " written to " + filename);
    PrintStream ps = new PrintStream(new FileOutputStream(new File(outFolder, filename)), false, StandardCharsets.UTF_8.toString());
    t.printStackTrace(ps);
    ps.close();
  }

  byte[] document2bytes(Document d) throws TransformerException {
    ByteArrayOutputStream os = new ByteArrayOutputStream();
    nullTransformer.transform(new DOMSource(d), new StreamResult(os));
    return os.toByteArray();
  }

  void writeDocument(File f, Document d) throws TransformerException {
    nullTransformer.transform(new DOMSource(d), new StreamResult(f));
  }

  private void writeException(String outFolder, String id, Document row, int line, Exception e) throws Exception {
    if (id == null) throw (e);
    String filename = "offending_row_" + id + ".xml";
    System.err.println("ERROR - Exception " + e + " caught @row " + line + " written to " + filename);
    e.printStackTrace();
    writeDocument(new File(outFolder, filename), row);
  }

  static void writeContent(File f, byte[] c) throws IOException {
    FileOutputStream fos = new FileOutputStream(f);
    fos.write(c);
    fos.close();
  }

  private void writeException(String outFolder, String id, byte[] content, int line, Exception e) throws Exception {
    String filename = "offending_node_" + id + ".xml";
    System.err.println("ERROR - Exception " + e + " caught @row " + line + " written to " + filename);
    writeContent(new File(outFolder, filename), content);
  }

  static DecimalFormat df = new DecimalFormat("0.0"), df7 = new DecimalFormat("0000000");
  int lastStartRow = 0;
  int rowCountFlush = 12 * 1024;
  private BufferedOutputStream bos = null;

  private void closeContent() throws IOException {
    if (bos != null) {
      bos.flush();
      bos.close();
      bos = null;
    }
  }

  private void flushContent(String itemId, int rows, String outFolder, int dataIndex, byte[] content) throws IOException {
    if (lastStartRow == 0 || rows - lastStartRow >= rowCountFlush) {
      if (bos != null) closeContent();
      String filename = "arco-knowledge-graph-1.0_R04_" + (dataIndex > 0 ? "" + dataIndex + "_" : "") + df7.format(rows) + ".nt.gz";
      System.out.println("STATUS - writing @" + filename);
      bos = new BufferedOutputStream(new GZIPOutputStream(new FileOutputStream(new File(outFolder, filename), false)));
      lastStartRow = rows;
    }
    bos.write(("# " + itemId + "\n").getBytes(StandardCharsets.UTF_8.toString()));
    bos.write(content);
    /*
    String lines[] = new String(content, StandardCharsets.UTF_8.toString()).split("\\r\\n|\\n|\\r");
    Set<String>xlines = new HashSet<String>(1024);
    for (String line:lines) xlines.add(line);
    xlines = new TreeSet<String>(xlines); // sort
    Iterator<String>it = xlines.iterator(); 
    while (it.hasNext()) bos.write((it.next()+"\n").getBytes(StandardCharsets.UTF_8.toString()));
     */
  }

  long startMillis;

  static String writePercentage(long n, long d) {
    return d > 0 ? "" + df.format(n * 100. / d) + "%" : "0";
  }

  static String writeRate(long n, long md) {
    if (md == 0) return "";
    return "@" + df.format(n * 1000. / md) + " rows/sec";
  }

  private void writeContent(String itemId, int pass, /*int passes,*/int csvLine, int rows, String outFolder, int dataIndex, ByteArrayOutputStream result)
      throws IOException {
    flushContent(itemId, rows, outFolder, dataIndex, result.toByteArray());
    if ((rows % 2048) == 0) {
      long now = new Date().getTime();
      System.out.println("STATUS - got " + rows + " rows " + writeRate(rows, now - startMillis)
          + (dataIndex > 0 ? "" : (pass > 1 ? " @line " + csvLine : "") + " @pass " + pass/*"/"+passes*/) + " (arco "
          + writePercentage(arcoMillis, now - startMillis) + ")");
    }
  }

  static FileSystem zfs = null;

  @SuppressWarnings("serial")
  static FileSystem zfs(String outFolder) throws IOException {
    if (zfs == null) zfs = FileSystems.newFileSystem(URI.create("jar:" + new File(outFolder, "dump.zip").toURI()), new HashMap<String, String>() {
      {
        put("create", "true");
      }
    });
    return zfs;
  };

  static void zWrite(String outFolder, String name, byte[] content) throws IOException {
    Files.write(zfs(outFolder).getPath(name), content, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING, StandardOpenOption.WRITE); // jre 1.8 bug: needs explicit option
  }

  @SuppressWarnings("unchecked")
  Map<String, String> addMap(DB db, String name) {
    return db.hashMap(name).keySerializer(org.mapdb.Serializer.STRING).valueSerializer(org.mapdb.Serializer.JAVA).createOrOpen();
  }

  void checkDbData() { //if (new File(PreprocessedData.dbFileName).exists()) return;
    DB db = DBMaker.fileDB(PreprocessedData.dbFileName).make();
    db.atomicLong("GENERATED").createOrOpen().set(System.currentTimeMillis());
    addMap(db, "ftan2URL");
    addMap(db, "catalogueRecordIdentifier2URI");
    addMap(db, "uniqueIdentifier2URIs");
    addMap(db, "contenitoreFisicoSystemRecordCode2CCF");
    addMap(db, "contenitoreGiuridicoSystemRecordCode2CCG");
    Map<String, String> map = addMap(db, "codiceEnteToNomeEnte");
    map.put("P021", "Provincia autonoma di Bolzano");
    db.commit();
    db.close();
  }

  int maxTry = 3, tryWait = 15, timeout = 15;

  String csvProperty(int pass) {
    return properties.getProperty("" + pass + ".csv");
  }

  CsvRow2domReader getPassReader(int pass) throws Exception {
    String csvUrl = csvProperty(pass);
    for (int tryCount = 1;; tryCount++) {
      try {
        System.out.println("STATUS - reading @" + csvUrl);
        String filterCell = properties.getProperty("" + pass + ".filterCell", "").trim();
        String charset = properties.getProperty("" + pass + ".charset"), separator = properties.getProperty("" + pass + ".separator");
        return new CsvRow2domReader(csvUrl, properties.getProperty("" + pass + ".splitter"), properties.getProperty("" + pass + ".split"), true, timeout, true,
            filter(filterCell, pass), filterCell, charset, separator);
      } catch (Exception e) {
        if (tryCount == maxTry) throw e;
        System.err.println("ERROR - failure @try " + tryCount + "/" + maxTry + " " + e);
        Thread.sleep(tryWait * 1000);
      }
    }
  }

  private Converter converter = null;

  //private Preprocessor preprocessor = null;
  void initializeArco() throws MalformedURLException, IOException {
    checkDbData();
    converter = new Converter(); /* preprocessor = new Preprocessor(".", ".", "https://w3id.org/arco/resource/"); */
  }

  void shutdownArco() { /*if (preprocessor!=null) {preprocessor.commit(); preprocessor.close();}*/
    if (converter != null) converter.destroy();
  }

  //void updateArco(Document d) throws XPathExpressionException { preprocessor.preprocessDomRecord(d); }
  long arcoMillis = 0;

  String toIsoDate(String s) throws ParseException {
    String[] a = s.split("/");
    if (a.length > 2)
      return (a[2].length() == 2 ? "20" : "") + a[2] + "-" + (a[1].length() < 2 ? "0" : "") + a[1] + "-" + (a[0].length() < 2 ? "0" : "") + a[0];
    SimpleDateFormat formatter = new SimpleDateFormat("MMMM d, yyyy", Locale.ITALIAN);
    Date date = formatter.parse(s);
    return datestampFormat().format(date);
  }

  //List<String>passes() { List<String>result = new ArrayList<String>(); for (int j=1;;j++) { String id = properties.getProperty("" + j + ".id"); if (id==null) break; result.add(id); } return result; }
  private XPath xPath = XPathFactory.newInstance().newXPath();

  Set<String> filter(String cell, int pass) {
    Set<String> result = null;
    if (cell == null || cell.length() == 0) return result;
    String filterList = properties.getProperty("" + pass + ".filterList", "").trim();
    if (filterList.length() == 0) return result;
    String[] filters = filterList.split(",");
    result = new HashSet<String>();
    for (int j = 0; j < filters.length; j++)
      result.add(filters[j]);
    return result;
  }

  int maxtry = 3, tryAfter = 5;//60; // sec

  List<String> extractUrl(String url, String selector, int maxCount, String attribute) {
    List<String> contents = new ArrayList<String>();
    org.jsoup.nodes.Document doc;
    for (int trycount = 1;; trycount++) {
      try {
        System.out.println("reading @" + url);
        doc = Jsoup.connect(url).get();
        //System.out.println(url+"\n"+doc.body().html());
        Elements results = doc.select(selector);
        int count = 0;
        for (org.jsoup.nodes.Element result : results) {
          contents.add(attribute == null ? result.html() : result.attr(attribute));
          if (maxCount > 0 && ++count == maxCount) break;
        }
        break;
      } catch (IOException e) {
        System.err.println("try #" + trycount + " failed with exception " + e + "  @" + url);
        if (trycount == maxtry) break;
        try {
          System.err.println("try " + (maxtry - trycount) + " times again after " + tryAfter + "sec");
          Thread.sleep(tryAfter * 1000);
        } catch (Exception ex) {
          ;
        }
      }
    }
    return contents;
  }

  String dateStamp(int dataIndex) throws Exception {
    return dateStamp(dataIndex, false);
  }

  Document url2dom(String url) throws IOException, SAXException {
    HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection();
    connection.setConnectTimeout(timeout * 1000);
    InputStream is = connection.getInputStream();
    Document result = db.parse(is);
    is.close();
    return result;
  }

  String dateStamp(int dataIndex, boolean read) throws Exception {
    String dateDocument = properties.getProperty("" + dataIndex + ".dateDocument");
    if (dateDocument != null) {
      for (int tryCount = 1;; tryCount++) {
        try {
          System.out.println("STATUS - reading @" + dateDocument);
          String datePath = properties.getProperty("" + dataIndex + ".datePath");
          String dateSelector = properties.getProperty("" + dataIndex + ".dateSelector");
          String result = datePath != null ? (String) xPath.evaluate(datePath, url2dom(dateDocument)) : extractUrl(dateDocument, dateSelector, 1, null).get(0);
          result = toIsoDate(result);
          System.out.println("INFO - dateStamp is " + result);
          return result;
        } catch (Exception e) {
          if (tryCount == maxTry) throw e;
          System.err.println("ERROR - failure @try " + tryCount + "/" + maxTry);
          Thread.sleep(tryWait * 1000);
        }
      }
    }
    if (!read) return null;
    String datePath = properties.getProperty("" + dataIndex + ".date");
    if (datePath == null) {
      URL url = new URL(csvProperty(dataIndex));
      if (url.getProtocol().compareToIgnoreCase("file") == 0) return datestampFormat().format(new Date(new File(url.getPath()).lastModified()));
      return null;
    }
    String passDate = null;
    CsvRow2domReader r2d = getPassReader(dataIndex);
    for (Document row; (row = r2d.next()) != null;) {
      String rowDate = (String) xPath.evaluate(datePath, row, XPathConstants.STRING);
      if (rowDate != null && rowDate.length() > 0 && (passDate == null || passDate.compareTo(rowDate) < 0)) passDate = rowDate;
    }
    r2d.close();
    return passDate;
  }

  String lastDate(List<String> dates) {
    String result = null;
    for (String date : dates)
      if (result == null || result.compareTo(date) < 0) result = date;
    return result;
  }

  String lastUpdateDate(int dataIndex) throws Exception {
    return lastUpdateDate(dataIndex, false);
  }

  String lastUpdateDate(int dataIndex, boolean read) throws Exception {
    List<String>/*ids = passes(),*/dates = new ArrayList<String>();
    for (int pass = dataIndex > 0 ? dataIndex : 1;; pass++) {
      if (dataIndex > 0 && pass > dataIndex) break;
      String date = dateStamp(pass, read);
      if (date == null) break;
      dates.add(date);
    }
    return lastDate(dates);
  }

  SimpleDateFormat datestampFormat() {
    return new SimpleDateFormat("yyyy-MM-dd");
  }

  void writeDateStamp(String date, String outFolder) throws UnsupportedEncodingException, IOException {
    Files.write(Paths.get(outFolder, "datestamp.isodate"), date.getBytes(StandardCharsets.UTF_8.toString()));
  }

  void datestamp(String outFolder, int dataIndex) throws Exception {
    writeDateStamp(lastUpdateDate(dataIndex, true), outFolder);
  }

  void convert(String outFolder, int dataIndex, boolean dump) throws Exception {
    try {
      initializeArco();
      Processor pro = new Processor(false);
      XsltCompiler xco = pro.newXsltCompiler();
      ByteArrayOutputStream baos = new ByteArrayOutputStream(), result = new ByteArrayOutputStream();
      Serializer out = pro.newSerializer(baos);
      int rows = 1;
      startMillis = new Date().getTime();
      String resourcePrefix = properties.getProperty("resourcePrefix", "https://w3id.org/arco/resource/AltoAdige/").trim();
      String nowDate = datestampFormat().format(new Date().getTime()), lastDate = null;
      PreprocessedData pd = PreprocessedData.getInstance(false);
      Map<String, String> cfMap = pd.getContenitoreFisicoSystemRecordCode2CCF();
      Map<String, String> cgMap = pd.getContenitoreGiuridicoSystemRecordCode2CCG();
      for (int pass = dataIndex > 0 ? dataIndex : 1;; pass++) {
        if (dataIndex > 0 && pass > dataIndex) break;
        String passDate = null;
        //Set<String>filter = null;
        String itemPath = properties.getProperty("" + pass + ".itemId"); //System.out.println("@id " + id);
        if (itemPath == null) break;
        String datePath = properties.getProperty("" + pass + ".date");
        String dataset = properties.getProperty("" + pass + ".dataset", "#" + pass);
        System.out.println("INFO - dataset " + dataset);
        String documentPrefix = properties.getProperty("" + pass + ".documentPrefix").trim();
        /*String cfPrefix = properties.getProperty("" + pass + ".cfPrefix");
        String cgPrefix = properties.getProperty("" + pass + ".cgPrefix");*/
        String date = dateStamp(pass); //dates.add(date); System.out.println("INFO - update date is " + date);
        if (date != null) passDate = date;
        XsltTransformer xtrRdf = null, xtr[] = null;
        String xslt = properties.getProperty("" + pass + ".xslt");
        if (xslt != null) {
          String[] ax = xslt.split(",");
          xtr = new XsltTransformer[ax.length];
          for (int j = 0; j < ax.length; j++) {
            String xsltUrl = this.getClass().getClassLoader().getResource(ax[j]).toExternalForm();
            String xsltBase = xsltUrl.substring(0, xsltUrl.lastIndexOf('/')) + "/";//System.out.println("transformer base => " + xsltBase);
            xtr[j] = xco.compile(new StreamSource(ras(ax[j]))).load();
            xtr[j].setParameter(new QName("xsltBase"), new XdmAtomicValue(xsltBase));
            xtr[j].setParameter(new QName("dataset"), new XdmAtomicValue(dataset));
            xtr[j].setDestination(out);
          }
        }
        String[] idPrefix = null;
        String pprefix = properties.getProperty("" + pass + ".idprefix");
        if (pprefix != null) idPrefix = pprefix.split(",");
        String[] cgmap = null;
        String pmap = properties.getProperty("" + pass + ".cgmap");
        if (pmap != null) cgmap = pmap.split(",");
        String[] cfmap = null;
        pmap = properties.getProperty("" + pass + ".cfmap");
        if (pmap != null) cfmap = pmap.split(",");

        //xtr.setParameter(new QName("datestamp"), new XdmAtomicValue(date));
        String xsltRdf = properties.getProperty("" + pass + ".2rdf.xslt");
        if (xsltRdf != null) {
          System.out.println("xsltRdf: " + xsltRdf);
          xtrRdf = xco.compile(new StreamSource(ras(xsltRdf))).load();
          xtrRdf.setDestination(out);
        }
        CsvRow2domReader r2d = getPassReader(pass);
        /*String rmp = properties.getProperty("" + pass + ".rmDup");
        if (rmp!=null) System.out.println("INFO - remove duplicates " + rmp + " @" + dataset);//String rmp = "row/cell[@name='NCTN']";
        Set<String>rmSet = new HashSet<String>();*/
        for (Document row; (row = r2d.next()) != null; rows++) {
          String rowitemId = null;
          try {/*
               if (filter!=null) {
                String filterValue = ((String)xPath.evaluate(filterPath, row, XPathConstants.STRING)).trim().toLowerCase();
                if (!filter.contains(filterValue)) {rows--; continue;}
               }*/
            rowitemId = safeIriPart((String) xPath.evaluate(itemPath, row, XPathConstants.STRING), "_");
            //"AA_CG_"+itemId;
            //row2rdf(itemId, row, itemPath, xtr, xtrRdf, baos, result, outFolder, line, dump);
            /*if (rmp!=null) { String rmc = (String)xPath.evaluate(rmp, row, XPathConstants.STRING);
             if (rmc.length()>0 && !rmSet.add(rmc)) { // avoid duplicate IRI
              Node dead = (Node)xPath.evaluate(rmp, row, XPathConstants.NODE);
              dead.getParentNode().removeChild(dead);    
              System.out.println("duplicate " + rmp + " " + rmc + " removed");
            }}*/
            String rowDate = passDate != null ? passDate : nowDate;
            if (datePath != null) {
              rowDate = (String) xPath.evaluate(datePath, row, XPathConstants.STRING);
              if (rowDate != null && rowDate.length() > 0) {
                if (passDate == null || passDate.compareTo(rowDate) < 0) passDate = rowDate;
              } else
                rowDate = passDate != null ? passDate : nowDate;
            }
            for (int xj = 0; (xtr == null && xj == 0) || xj < xtr.length; xj++) {
              String itemId = (idPrefix != null ? idPrefix[xj] : "") + rowitemId;
              byte[] ba = null;
              Model model = null;
              if (xtr != null) {
                baos.reset();
                xtr[xj].setParameter(new QName("datestamp"), new XdmAtomicValue(rowDate));
                if (dump) zWrite(outFolder, itemId + ".csv2.xml", document2bytes(row));
                xtr[xj].setSource(new DOMSource(row)); //System.out.println("@id " + itemId);      
                xtr[xj].transform();
                ba = baos.toByteArray();
                if (dump) zWrite(outFolder, itemId + ".xml", ba);

                long start = new Date().getTime();
                try { //updateArco(db.parse(new ByteArrayInputStream(ba)));
                  model = converter.convert(itemId, resourcePrefix, documentPrefix, new ByteArrayInputStream(ba));
                } catch (Exception e) {
                  writeException(outFolder, itemId, ba, r2d.line(), e);
                  continue;
                } finally {
                  arcoMillis += new Date().getTime() - start;
                }
              }
              if (xtrRdf != null) {
                baos.reset();
                //xtrRdf.setSource(new DOMSource(db.parse(new ByteArrayInputStream(ba))));
                xtrRdf.setSource(new DOMSource(ba != null ? db.parse(new ByteArrayInputStream(ba)) : row));
                xtrRdf.transform();
                Model xModel = ModelFactory.createDefaultModel();
                xModel.read(new ByteArrayInputStream(baos.toByteArray()), null, "RDF/XML");
                if (model != null)
                  model.add(xModel);
                else
                  model = xModel;
              }
              model.write(result, "N-TRIPLES");
              //writeContent(itemId, pass, ids.size(), r2d.line(), rows, outFolder, dataIndex, result);
              writeContent(itemId, pass, r2d.line(), rows, outFolder, dataIndex, result);
              // la trasformazione usa una mappa per risalire dal bene al contenitore
              if (cgmap != null && Boolean.valueOf(cgmap[xj])) cgMap.put(rowitemId, itemId);
              if (cfmap != null && Boolean.valueOf(cfmap[xj])) cfMap.put(rowitemId, itemId);
            }
          } catch (Exception e) {
            writeException(outFolder, rowitemId, row, r2d.line(), e);
          } finally {
            result.reset();
            baos.reset();
          }
          if (passDate != null && (lastDate == null || lastDate.compareTo(passDate) < 0)) lastDate = passDate;
          //if (line==2) break; // test
        }
        System.out.println("STATUS - got " + r2d.line() + " lines @dataset " + dataset);
        r2d.close();
      }
      closeContent();
      pd.commit();
      pd.close();
      writeDateStamp(lastDate != null ? lastDate : nowDate, outFolder);//writeDateStamp(lastDate(dates), outFolder);
    } finally {
      shutdownArco();
      if (zfs != null) zfs.close();
    }
  }

  static void uso() {
    System.err.println("uso: java -jar rdfAltoAdige-0.0.1-full.jar <output folder> [-dump] [-datestamp] [-dataset:<index>]");
    System.exit(-1);
  }

  public static void main(String[] args) throws Exception {
    if (args.length < 1) uso();
    String outFolder = args[0];
    boolean datestamp = false, dump = false;
    int dataIndex = -1;
    for (int j = 1; j < args.length; j++) {
      if (args[j].compareTo("-datestamp") == 0) {
        datestamp = true;
        continue;
      }
      if (args[j].compareTo("-dump") == 0) {
        dump = true;
        continue;
      }
      if (args[j].startsWith("-dataset:")) {
        dataIndex = Integer.parseInt(args[j].substring(9));
        continue;
      }
      uso();
    }
    RdfAltoAdige rdfaa = new RdfAltoAdige();
    try {
      if (datestamp)
        rdfaa.datestamp(outFolder, dataIndex);
      else
        rdfaa.convert(outFolder, dataIndex, dump);
    } catch (Throwable t) {
      fatal(outFolder, t);
    }
  }
}
