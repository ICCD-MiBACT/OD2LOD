package it.beniculturali.dati.od2lod.rdfRegioni.veneto;

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
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
import javax.xml.xpath.XPathFactory;

import org.apache.jena.rdf.model.Model;
import org.mapdb.DB;
import org.mapdb.DBMaker;
import org.w3c.dom.Document;

import it.cnr.istc.stlab.arco.Converter;
import it.cnr.istc.stlab.arco.Urifier;
import it.cnr.istc.stlab.arco.preprocessing.PreprocessedData;
import it.cnr.istc.stlab.arco.xsltextension.Utilities;
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

  byte[] document2bytes(Document d) throws TransformerException {
    ByteArrayOutputStream os = new ByteArrayOutputStream();
    nullTransformer.transform(new DOMSource(d), new StreamResult(os));
    return os.toByteArray();
  }

  void writeDocument(File f, Document d) throws TransformerException {
    nullTransformer.transform(new DOMSource(d), new StreamResult(f));
  }

  private void writeException(String outFolder, String id, Document card, Exception e) throws Exception {
    if (id == null) throw (e);
    String filename = "offending_card_" + id + ".xml";
    System.err.println("ERROR - Exception " + e + " caught @card " + id + " written to " + filename);
    //writeDocument(new File(outFolder, filename), card);
    if (card != null) writeOffense(outFolder, filename, document2bytes(card));
    e.printStackTrace();
  }

  //static void writeContent(File f, byte[]c) throws IOException { FileOutputStream fos = new FileOutputStream(f); fos.write(c); fos.close(); }
  private void writeException(String outFolder, String id, byte[] content, Exception e) throws Exception {
    String filename = "offending_node_" + id + ".xml";
    System.err.println("ERROR - Exception " + e + " caught @card " + id + " written to " + filename);
    //writeContent(new File(outFolder, filename), content);
    if (content != null) writeOffense(outFolder, filename, content);
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

  private void flushContent(String ids, String itemId, int rows, String outFolder, byte[] content) throws IOException {
    if (lastStartRow == 0 || rows - lastStartRow >= rowCountFlush) {
      if (bos != null) closeContent();
      String filename = "arco-knowledge-graph-1.0_R05_" + df7.format(rows) + (ids == null ? "" : "-" + itemId + "-cards") + ".nt.gz";
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

  private void writeContent(String ids, String itemId, int cardsCount, String outFolder, ByteArrayOutputStream result) throws IOException {
    flushContent(ids, itemId, cardsCount, outFolder, result.toByteArray());
    if ((cardsCount % 2048) == 0) {
      long now = new Date().getTime();
      System.out.println("STATUS - got " + cardsCount + " cards " + writeRate(cardsCount, now - startMillis) + " (arco "
          + writePercentage(arcoMillis, now - startMillis) + ")");
    }
  }

  static FileSystem dump = null;

  static FileSystem dump(String outFolder) throws IOException {
    if (dump == null) dump = Zip.create(outFolder, "dump");
    return dump;
  };

  static void writeDump(String outFolder, String name, byte[] content) throws IOException {
    Zip.write(dump(outFolder), name, content);
  }

  static void closeDump() throws IOException {
    Zip.close(dump);
    dump = null;
  }

  static FileSystem offense = null;

  static FileSystem offense(String outFolder) throws IOException {
    if (offense == null) offense = Zip.create(outFolder, "offense");
    return offense;
  };

  static void writeOffense(String outFolder, String name, byte[] content) throws IOException {
    Zip.write(offense(outFolder), name, content);
  }

  static void closeOffense() throws IOException {
    Zip.close(offense);
    offense = null;
  }

  static FileSystem cache = null;

  static FileSystem cache(String outFolder) throws IOException {
    if (cache == null) cache = Zip.create(outFolder, "cache");
    return cache;
  };

  static void writeCache(String outFolder, String name, byte[] content) throws IOException {
    Zip.write(cache(outFolder), name, content);
  }

  static void closeCache() throws IOException {
    Zip.close(cache);
    cache = null;
  }

  @SuppressWarnings("unchecked")
  static void addMap(DB db, String name) {
    db.hashMap(name).keySerializer(org.mapdb.Serializer.STRING).valueSerializer(org.mapdb.Serializer.JAVA).createOrOpen();
  }

  static void checkDbData() { //if (new File(PreprocessedData.dbFileName).exists()) return;
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

  DocumentReader serviceReader(String id, String outFolder) throws Exception {
    String q = null;
    if (id != null) q = properties.getProperty("cardQuery").replaceAll("\\$\\(id\\)", URLEncoder.encode("\"" + id + "\"", StandardCharsets.UTF_8.toString()));
    if (q == null) {
      File z = new File(outFolder, "dump.zip");
      if (z.exists()) return new ServiceZipReader(z);
      q = properties.getProperty("contentQuery"); //System.out.println("STATUS - reading @" + q);
    }
    return new ServiceReader(q, properties.getProperty("contentData"), properties.getProperty("contentCount"));
  }

  void preprocessMessage(int count, int offense, long start, boolean last) {
    long now = new Date().getTime();
    System.out.println("STATUS - pre-processed " + (count - offense) + (last ? "/" + count : "") + " cards " + writeRate(count, now - start));
  }

  CardZipReader preprocess(String outFolder, String id) throws Exception {
    PreprocessedData pd = PreprocessedData.getInstance(false);
    Map<String, String> map = pd.getCatalogueRecordIdentifier2URI();
    Processor pro = new Processor(false);
    XsltCompiler xco = pro.newXsltCompiler();
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    Serializer out = pro.newSerializer(baos);
    String NCTPath = properties.getProperty("NCT");
    String RVELPath = properties.getProperty("RVEL");
    String itemPath = properties.getProperty("itemId");
    String sheetTypePath = properties.getProperty("sheetType");
    String resourcePrefix = properties.getProperty("resourcePrefix");
    XsltTransformer xtr = xco.compile(new StreamSource(ras(properties.getProperty("xslt")))).load()/*, xtrRdf = null*/;
    xtr.setDestination(out);
    int count = 0, offense = 0;
    long start = new Date().getTime();
    String[] ids = id == null ? new String[] { null } : id.split(":");
    List<String> itemIds = new ArrayList<String>();
    XPath xPath = XPathFactory.newInstance().newXPath();
    for (String cardId : ids) {
      DocumentReader sr = serviceReader(cardId, outFolder);
      boolean dump = ServiceReader.class.isInstance(sr);
      for (Document card; (card = sr.next()) != null;) {
        String itemId = null;
        try {
          itemId = (String) xPath.evaluate(itemPath, card, XPathConstants.STRING);
          String sheetType = (String) xPath.evaluate(sheetTypePath, card, XPathConstants.STRING);
          String specificPropertyType = Utilities.getLocalName(Utilities.getSpecificPropertyType(sheetType));
          String NCTN = (String) xPath.evaluate(NCTPath + "/NCTN", card, XPathConstants.STRING);
          String RVEL = (String) xPath.evaluate(RVELPath, card, XPathConstants.STRING);
          if (NCTN.length() > 0) {//String NCTR = (String)xPath.evaluate(NCTPath + "/NCTR", card, XPathConstants.STRING);String NCTS = (String)xPath.evaluate(NCTPath + "/NCTS", card, XPathConstants.STRING);
            String NCT = (String) xPath.evaluate("concat(" + NCTPath + "/NCTR,'" + NCTN + "'," + NCTPath + "/NCTS)", card, XPathConstants.STRING);
            String identifier = NCT + (RVEL.length() > 0 ? "-" + RVEL : "");//System.out.println(identifier+" <= "+map.get(identifier));
            String resource = resourcePrefix + specificPropertyType + "/" + NCT + (RVEL.length() > 0 ? "-" + Urifier.toURI(RVEL) : "");
            map.put(identifier, resource);//System.out.println(identifier+" => "+resource);//System.out.println(itemId+(RVEL.length()>0?"-"+RVEL:"")+" <= "+map.get(itemId));
            map.put(itemId + (RVEL.length() > 0 ? "-" + RVEL : ""), resource);//System.out.println(itemId+(RVEL.length()>0?"-"+RVEL:"")+" => "+resource);
            //if (RVEL.length()==0) { map.put(NCT+"-0", resource); map.put(itemId+"-0", resource); }
            if (RVEL.length() > 0) {
              map.put(NCT, resource);
              map.put(itemId, resource);
            }
          } else {
            String resource = resourcePrefix + specificPropertyType + "/" + itemId + (RVEL.length() > 0 ? "-" + Urifier.toURI(RVEL) : "");
            map.put(itemId + (RVEL.length() > 0 ? "-" + RVEL : ""), resource);
            //if (RVEL.length()==0) map.put(itemId+"-0", resource);
            if (RVEL.length() > 0) map.put(itemId, resource);
          }
          itemId = safeIriPart(itemId, "_");
          if (dump) writeDump(outFolder, itemId, document2bytes(card));
          xtr.setSource(new DOMSource(card)); //System.out.println("@id " + itemId);
          xtr.transform();
          byte[] ba = baos.toByteArray();
          writeCache(outFolder, itemId, ba);
          itemIds.add(itemId);
        } catch (Exception e) {
          writeException(outFolder, itemId, card, e);
          offense++;
        } finally {
          baos.reset();
        }
        //if (cardsCount==2) break; // test
        if ((++count % 2048) == 0) preprocessMessage(count, offense, start, false);
      }
      if (dump) closeDump();
      sr.close();
    }
    pd.commit();
    //pd.close();
    preprocessMessage(count, offense, start, true);
    return new CardZipReader(cache(outFolder), itemIds);
  }

  static Converter converter = null;

  static void initializeArco() throws MalformedURLException, IOException {
    converter = new VenetoConverter(); /* preprocessor = new Preprocessor(".", ".", "https://w3id.org/arco/resource/"); */
  }

  static void shutdownArco() { /*if (preprocessor!=null) {preprocessor.commit(); preprocessor.close();}*/
    if (converter != null) {
      converter.destroy();
      converter = null;
    }
  }

  long arcoMillis = 0;

  CardZipReader cardReader(String outFolder, String id) throws Exception {
    File z = new File(outFolder, "cache.zip");
    if (!z.exists() || id != null) return preprocess(outFolder, id);
    return new CardZipReader(cache(outFolder), id == null ? null : Arrays.asList(id.split(":")));
  }

  String toIsoDate(String s) {
    String[] a = s.split("/");
    return (a[2].length() == 2 ? "20" : "") + a[2] + "-" + (a[1].length() < 2 ? "0" : "") + a[1] + "-" + (a[0].length() < 2 ? "0" : "") + a[0];
  }

  void convert(String outFolder, String id) throws Exception {
    try {
      checkDbData();
      CardZipReader cr = cardReader(outFolder, id);
      ByteArrayOutputStream result = new ByteArrayOutputStream();
      int cardsCount = 0, offense = 0;
      startMillis = new Date().getTime();
      String documentPrefix = properties.getProperty("documentPrefix").trim();
      String resourcePrefix = properties.getProperty("resourcePrefix", "https://w3id.org/arco/resource/Veneto/").trim();
      initializeArco();
      String xsltRdf = properties.getProperty("2rdf.xslt");
      if (xsltRdf != null) {
        converter.addXSTLConverter(Paths.get(this.getClass().getClassLoader().getResource(xsltRdf).toURI()));
      }
      for (byte[] ba; (ba = cr.next()) != null;) {
        String itemId = cr.name();
        try {
          Model model;
          long start = new Date().getTime();
          try {
            model = converter.convert(itemId, resourcePrefix, documentPrefix, new ByteArrayInputStream(ba));
          } catch (Exception e) {
            writeException(outFolder, itemId, ba, e);
            offense++;
            continue;
          } finally {
            arcoMillis += new Date().getTime() - start;
          }
          model.write(result, "N-TRIPLES");
          writeContent(id, itemId, ++cardsCount, outFolder, result);
        } catch (Exception e) {
          writeException(outFolder, itemId, ba, e);
        } finally {
          result.reset();
        }
      }
      System.out.println("STATUS - got " + cardsCount + "/" + (cardsCount + offense) + " cards");
      closeContent();
    } finally {
      close();
    }
  }

  static void close() {
    try {
      shutdownArco();
    } catch (Exception e) {
      System.err.println("ERROR - got Exception " + e + " shutting down ArCo");
    }
    try {
      closeCache();
    } catch (Exception e) {
      System.err.println("ERROR - got Exception " + e + " closing cache");
    }
    try {
      closeDump();
    } catch (Exception e) {
      System.err.println("ERROR - got Exception " + e + " closing dump");
    }
    try {
      closeOffense();
    } catch (Exception e) {
      System.err.println("ERROR - got Exception " + e + " closing offense");
    }
  }

  static void uso() {
    System.err.println("uso: java -jar rdfVeneto-0.0.1-full.jar <output folder> [-card:<id>]");
    System.exit(-1);
  }

  public static void main(String[] args) throws Exception {
    if (args.length < 1) uso();
    String outFolder = args[0], id = null;// boolean dump = true;  
    for (int j = 1; j < args.length; j++) { // System.out.println("args["+j+"]: " + args[j]);
      //if (args[j].compareTo("-dump")==0) { dump = true; continue; }
      if (args[j].startsWith("-card:")) {
        id = args[j].substring(6);
        continue;
      }
      if (args[j].compareTo("-map") == 0) {
        Map<String, String> map = PreprocessedData.getInstance(false).getCatalogueRecordIdentifier2URI();
        for (Map.Entry<String, String> entry : map.entrySet())
          System.out.println(entry.getKey() + " => " + entry.getValue());
        System.exit(0);
      }
      uso();
    }
    Runtime.getRuntime().addShutdownHook(new Thread() {
      public void run() {
        close();
      }
    });
    RdfVeneto rdfv = new RdfVeneto();
    try {
      rdfv.convert(outFolder, id);
    } catch (Throwable t) {
      fatal(outFolder, t);
    }
  }
}
