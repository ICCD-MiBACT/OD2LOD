package it.beniculturali.dati.od2lod.rdfRegioni;

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
import java.net.MalformedURLException;
import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.StandardOpenOption;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;
import java.util.zip.GZIPOutputStream;

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
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;
import org.mapdb.DB;
import org.mapdb.DBMaker;
import org.w3c.dom.Element;
import org.xml.sax.SAXException;

import it.cnr.istc.stlab.arco.Converter;
import it.cnr.istc.stlab.arco.preprocessing.PreprocessedData;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.Serializer;
import net.sf.saxon.s9api.XsltCompiler;
import net.sf.saxon.s9api.XsltTransformer;

public class RdfVeneto {
  private Transformer nullTransformer;

  RdfVeneto() throws IOException, TransformerConfigurationException, TransformerFactoryConfigurationError, ParserConfigurationException {
    loadProperties();
    nullTransformer = TransformerFactory.newInstance().newTransformer();
  }

  InputStream ras(String s) {
    return this.getClass().getClassLoader().getResourceAsStream(s);
  }

  Properties properties = new Properties();

  void loadProperties() throws IOException {
    InputStream is = ras("rdfVeneto.properties");
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

  byte[] element2bytes(Element e) throws TransformerException {
    ByteArrayOutputStream os = new ByteArrayOutputStream();
    nullTransformer.transform(new DOMSource(e), new StreamResult(os));
    return os.toByteArray();
  }

  void writeElement(File f, Element e) throws TransformerException {
    nullTransformer.transform(new DOMSource(e), new StreamResult(f));
  }

  private void writeException(String outFolder, String id, Element card, int line, Exception e) throws Exception {
    if (id == null) throw (e);
    String filename = "offending_card_" + id + ".xml";
    System.err.println("ERROR - Exception " + e + " caught @card " + line + " written to " + filename);
    writeElement(new File(outFolder, filename), card);
  }

  static void writeContent(File f, byte[] c) throws IOException {
    FileOutputStream fos = new FileOutputStream(f);
    fos.write(c);
    fos.close();
  }

  private void writeException(String outFolder, String id, byte[] content, int line, Exception e) throws Exception {
    String filename = "offending_node_" + id + ".xml";
    System.err.println("ERROR - Exception " + e + " caught @card " + line + " written to " + filename);
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
      String filename = "arco-knowledge-graph-1.0_R05_" + (dataIndex > 0 ? "" + dataIndex + "_" : "") + df7.format(rows) + ".nt.gz";
      System.out.println("STATUS - writing @" + filename);
      bos = new BufferedOutputStream(new GZIPOutputStream(new FileOutputStream(new File(outFolder, filename), false)));
      lastStartRow = rows;
    }
    bos.write(("# " + itemId + "\n").getBytes(StandardCharsets.UTF_8.toString()));
    bos.write(content);
  }

  long startMillis;

  static String writePercentage(long n, long d) {
    return d > 0 ? "" + df.format(n * 100. / d) + "%" : "0";
  }

  static String writeRate(long n, long md) {
    if (md == 0) return "";
    return "@" + df.format(n * 1000. / md) + " cards/sec";
  }

  private void writeContent(String itemId, int pass, int passes, int passCount, int cardsCount, String outFolder, int dataIndex, ByteArrayOutputStream result)
      throws IOException {
    flushContent(itemId, cardsCount, outFolder, dataIndex, result.toByteArray());
    if ((cardsCount % 2048) == 0) {
      long now = new Date().getTime();
      System.out.println("STATUS - got " + cardsCount + " cards " + writeRate(cardsCount, now - startMillis)
          + (dataIndex > 0 ? "" : (pass > 1 ? " @line " + passCount + " of" : "") + " @pass " + pass + "/" + passes) + " (arco "
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
  void addMap(DB db, String name) {
    db.hashMap(name).keySerializer(org.mapdb.Serializer.STRING).valueSerializer(org.mapdb.Serializer.JAVA).createOrOpen();
  }

  void checkDbData() { //if (new File(PreprocessedData.dbFileName).exists()) return;
    DB db = DBMaker.fileDB(PreprocessedData.dbFileName).make();
    db.atomicLong("GENERATED").createOrOpen().set(System.currentTimeMillis());
    addMap(db, "ftan2URL");
    addMap(db, "catalogueRecordIdentifier2URI");
    addMap(db, "uniqueIdentifier2URIs");
    addMap(db, "contenitoreFisicoSystemRecordCode2CCF");
    addMap(db, "contenitoreGiuridicoSystemRecordCode2CCG");
    addMap(db, "codiceEnteToNomeEnte");
    db.commit();
    db.close();
  }

  ListOfCardReader getPassReader(String inFolder, String id, int pass) throws XPathExpressionException, ParserConfigurationException, SAXException, IOException {
    String content = (inFolder == null ? properties.getProperty("source") : inFolder).replaceAll("\\$\\(id\\)", id);
    System.out.println("STATUS - reading @" + content);
    return new ListOfCardReader(content, properties.getProperty("nodePath"));
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

  String toIsoDate(String s) {
    String[] a = s.split("/");
    return (a[2].length() == 2 ? "20" : "") + a[2] + "-" + (a[1].length() < 2 ? "0" : "") + a[1] + "-" + (a[0].length() < 2 ? "0" : "") + a[0];
  }

  List<String> passes() {
    List<String> result = new ArrayList<String>();
    for (int j = 1;; j++) {
      String id = properties.getProperty("" + j + ".id");
      if (id == null) break;
      result.add(id);
    }
    return result;
  }

  private XPath xPath = XPathFactory.newInstance().newXPath();

  void convert(String inFolder, String outFolder, int dataIndex, boolean dump) throws Exception {
    try {
      initializeArco();
      Processor pro = new Processor(false);
      XsltCompiler xco = pro.newXsltCompiler();
      ByteArrayOutputStream baos = new ByteArrayOutputStream(), result = new ByteArrayOutputStream();
      Serializer out = pro.newSerializer(baos);
      List<String> ids = passes();
      int cardsCount = 1;
      startMillis = new Date().getTime();
      String resourcePrefix = properties.getProperty("resourcePrefix", "https://w3id.org/arco/resource/Veneto/").trim();
      for (int pass = 1; pass <= ids.size(); pass++) {
        if (dataIndex > 0 && pass != dataIndex) continue;
        int passCount = 1;
        String dataset = properties.getProperty("" + pass + ".dataset", "#" + pass);
        System.out.println("INFO - dataset " + dataset);
        String id = ids.get(pass - 1), itemPath = properties.getProperty("" + pass + ".itemId"); //System.out.println("@id " + id);
        String documentPrefix = properties.getProperty("" + pass + ".documentPrefix").trim();
        XsltTransformer xtrRdf = null, xtr = xco.compile(new StreamSource(ras(properties.getProperty("" + pass + ".xslt")))).load();
        xtr.setDestination(out);
        String xsltRdf = properties.getProperty("" + pass + ".2rdf.xslt");
        if (xsltRdf != null) {
          System.out.println("xsltRdf: " + xsltRdf);
          xtrRdf = xco.compile(new StreamSource(ras(xsltRdf))).load();
          xtrRdf.setDestination(out);
        }
        ListOfCardReader lcr = getPassReader(inFolder, id, pass);
        for (Element card; (card = lcr.next()) != null; passCount++, cardsCount++) {
          String itemId = null;
          try {
            itemId = safeIriPart((String) xPath.evaluate(itemPath, card, XPathConstants.STRING), "_");
            //row2rdf(itemId, row, itemPath, xtr, xtrRdf, baos, result, outFolder, line, dump);     
            if (dump) zWrite(outFolder, itemId + ".pre.xml", element2bytes(card));
            xtr.setSource(new DOMSource(card)); //System.out.println("@id " + itemId);      
            xtr.transform();
            Model model;
            byte[] ba = baos.toByteArray();
            if (dump) zWrite(outFolder, itemId + ".post.xml", ba);
            long start = new Date().getTime();
            try { //updateArco(db.parse(new ByteArrayInputStream(ba)));
              model = converter.convert(itemId, resourcePrefix, documentPrefix, new ByteArrayInputStream(ba));
            } catch (Exception e) {
              writeException(outFolder, itemId, ba, passCount, e);
              continue;
            } finally {
              arcoMillis += new Date().getTime() - start;
            }
            if (xtrRdf != null) {
              baos.reset();
              xtrRdf.setSource(new DOMSource(card));
              xtrRdf.transform();
              Model xModel = ModelFactory.createDefaultModel();
              ba = baos.toByteArray();
              if (dump) zWrite(outFolder, itemId + ".last.xml", ba);
              xModel.read(new ByteArrayInputStream(ba), null, "RDF/XML");
              model.add(xModel);
            }
            model.write(result, "N-TRIPLES");
            writeContent(itemId, pass, ids.size(), passCount, cardsCount, outFolder, dataIndex, result);
          } catch (Exception e) {
            writeException(outFolder, itemId, card, passCount, e);
          } finally {
            result.reset();
            baos.reset();
          }
          //if (cardsCount==2) break; // test
        }
        System.out.println("STATUS - got " + passCount + " cards @dataset " + dataset);
        lcr.close();
      }
      closeContent();
    } finally {
      shutdownArco();
      if (zfs != null) {
        zfs.close();
        zfs = null;
      }
    }
  }

  static void uso() {
    System.err.println("uso: java -jar rdfVeneto-0.0.1-full.jar <output folder> [-source:<input folder>] [-dump] [-dataset:<index>]");
    System.exit(-1);
  }

  public static void main(String[] args) throws Exception {
    if (args.length < 1) uso();
    String inFolder = null, outFolder = args[0];
    boolean dump = false;
    int dataIndex = -1;
    for (int j = 2; j < args.length; j++) {
      if (args[j].compareTo("-dump") == 0) {
        dump = true;
        continue;
      }
      if (args[j].startsWith("-dataset:")) {
        dataIndex = Integer.parseInt(args[j].substring(9));
        continue;
      }
      if (args[j].startsWith("-source:")) {
        inFolder = args[j].substring(8);
        continue;
      }
      uso();
    }
    RdfVeneto rdfv = new RdfVeneto();
    try {
      rdfv.convert(inFolder, outFolder, dataIndex, dump);
    } catch (Throwable t) {
      fatal(outFolder, t);
      if (zfs != null) {
        zfs.close();
        zfs = null;
      }
    }
  }
}
