package it.beniculturali.dati.od2lod.rdfRegioni.trento;

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.charset.StandardCharsets;
import java.nio.file.DirectoryStream;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.nio.file.StandardOpenOption;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
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
import org.mapdb.DB;
import org.mapdb.DBMaker;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import it.cnr.istc.stlab.arco.Converter;
import it.cnr.istc.stlab.arco.preprocessing.PreprocessedData;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.Serializer;
import net.sf.saxon.s9api.XdmAtomicValue;
import net.sf.saxon.s9api.XsltCompiler;
import net.sf.saxon.s9api.XsltTransformer;

public class RdfTrento {
  private DocumentBuilder db;
  private Transformer nullTransformer;

  RdfTrento() throws IOException, TransformerConfigurationException, TransformerFactoryConfigurationError, ParserConfigurationException {
    db = DocumentBuilderFactory.newInstance().newDocumentBuilder();
    loadProperties();
    nullTransformer = TransformerFactory.newInstance().newTransformer();
  }

  InputStream ras(String s) {
    return this.getClass().getClassLoader().getResourceAsStream(s);
  }

  Properties properties = new Properties();

  void loadProperties() throws IOException {
    InputStream is = ras("rdfTrento.properties");
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

  byte[] node2bytes(Node n) throws TransformerException {
    ByteArrayOutputStream os = new ByteArrayOutputStream();
    nullTransformer.transform(new DOMSource(n), new StreamResult(os));
    return os.toByteArray();
  }

  void writeNode(File f, Node n) throws TransformerException {
    nullTransformer.transform(new DOMSource(n), new StreamResult(f));
  }

  private void writeException(String outFolder, String id, Node n, int line, Exception e) throws Exception {
    if (id == null) throw (e);
    String filename = "offending_row_" + id + ".xml";
    System.err.println("ERROR - Exception " + e + " caught @row " + line + " written to " + filename);
    writeNode(new File(outFolder, filename), n);
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
      String filename = "arco-knowledge-graph-1.0_R03_" + (dataIndex > 0 ? "" + dataIndex + "_" : "") + df7.format(rows) + ".nt.gz";
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
    return "@" + df.format(n * 1000. / md) + " rows/sec";
  }

  private void writeContent(String itemId, int pass, int passes, int csvLine, int rows, String outFolder, int dataIndex, ByteArrayOutputStream result)
      throws IOException {
    flushContent(itemId, rows, outFolder, dataIndex, result.toByteArray());
    if ((rows % 2048) == 0) {
      long now = new Date().getTime();
      System.out.println("STATUS - got " + rows + " rows " + writeRate(rows, now - startMillis)
          + (dataIndex > 0 ? "" : (pass > 1 ? " @line " + csvLine : "") + " @pass " + pass + "/" + passes) + " (arco "
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

  void checkDbData() {
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
    PreprocessedData pd = PreprocessedData.getInstance(false);
    Map<String, String> map = pd.getCodiceEnteToNomeEnte();
    map.put("S222", "Provincia Autonoma di Trento - Soprintendenza per i Beni Culturali");
    pd.commit();
  }

  void remove(File dir) {
    File[] contents = dir.listFiles();
    if (contents != null) for (File file : contents)
      remove(file);
    dir.delete();
  }

  String fileWithEnd(Path dir, String end) throws IOException {
    DirectoryStream<Path> stream = Files.newDirectoryStream(dir);
    for (Path path : stream)
      if (!Files.isDirectory(path)) {
        String p = path.getFileName().toString();
        if (p.endsWith(end)) return path.toString();
      }
    return null;
  }

  void runProcess(String command, String params) throws IOException {
    System.out.println("starting process " + command + params);
    Process process = Runtime.getRuntime().exec(new String[] { "cmd", "/c", command + params, "2>&1" }, null, new File(command).getParentFile());
    InputStream stdout = process.getInputStream();
    BufferedReader reader = new BufferedReader(new InputStreamReader(stdout));
    String line;
    while ((line = reader.readLine()) != null)
      System.out.println(line);
    reader.close();
    System.out.println("done with process " + command);
  }

  int maxTry = 3, tryWait = 15, timeout = 15;

  @SuppressWarnings("serial")
  XPathReader getPassReader(String id, int pass, String outFolder) throws Exception {
    String content = properties.getProperty("content");
    String contentUrl = content.replaceAll("\\$\\(id\\)", id);
    URL url = new URL(contentUrl);
    Path tempDir = Files.createTempDirectory(id);
    File zipFile = new File(tempDir.toString(), id + ".zip");
    for (int tryCount = 1;; tryCount++) {
      try {
        System.out.println("STATUS - reading @" + contentUrl);
        ReadableByteChannel rbc = Channels.newChannel(url.openStream());
        FileOutputStream fos = new FileOutputStream(zipFile);
        fos.getChannel().transferFrom(rbc, 0, Integer.MAX_VALUE);
        fos.close();
        break;
      } catch (Exception e) {
        if (tryCount == maxTry) {
          remove(tempDir.toFile());
          throw e;
        }
        System.err.println("ERROR - failure @try " + tryCount + "/" + maxTry);
        Thread.sleep(tryWait * 1000);
      }
    }
    FileSystem z = null;
    try {
      z = FileSystems.newFileSystem(URI.create("jar:" + zipFile.toURI()), new HashMap<String, Object>() {
        {
        }
      });
      Iterable<Path> dirs = z.getRootDirectories(); // assuming root only
      for (Path dir : dirs) {
        DirectoryStream<Path> stream = Files.newDirectoryStream(dir);
        for (Path file : stream)
          Files.copy(file, Paths.get(tempDir.toString(), file.getFileName().toString()), StandardCopyOption.REPLACE_EXISTING);
      }
      String shp = fileWithEnd(tempDir, ".shp");
      String shape2gml = properties.getProperty("shape2gml");
      File gml = new File(outFolder, id + ".gml");
      runProcess(shape2gml, " \"" + shp + "\" \"" + gml + "\"");
      return new XPathReader(Paths.get("" + gml).toUri().toURL().toString(), "/*/*[local-name()='featureMember']");
    } finally {
      if (z != null) z.close();
      remove(tempDir.toFile());
    }
  }

  private Converter converter = null;

  void initializeArco() throws MalformedURLException, IOException {
    checkDbData();
    converter = new Converter();
  }

  void shutdownArco() {
    if (converter != null) converter.destroy();
  }

  long arcoMillis = 0;

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

  String dateStamp(String id) throws Exception {
    Document content = null;
    String dateDocument = properties.getProperty("dateDocument").replaceAll("\\$\\(id\\)", id);
    for (int tryCount = 1;; tryCount++) {
      try {
        System.out.println("STATUS - reading @" + dateDocument);
        HttpURLConnection connection = (HttpURLConnection) new URL(dateDocument).openConnection();
        connection.setConnectTimeout(timeout * 1000);
        InputStream is = connection.getInputStream();
        content = db.parse(is);
        is.close();
        break;
      } catch (Exception e) {
        if (tryCount == maxTry) throw e;
        System.err.println("ERROR - failure @try " + tryCount + "/" + maxTry);
        Thread.sleep(tryWait * 1000);
      }
    }
    String result = (String) xPath.evaluate(properties.getProperty("datePath").replaceAll("\\$\\(id\\)", id), content);
    System.out.println("INFO - update date is " + result);
    return result;
  }

  String lastDate(List<String> dates) {
    String result = null;
    for (String date : dates)
      if (result == null || result.compareTo(date) < 0) result = date;
    return result;
  }

  String lastUpdateDate(int dataIndex) throws Exception {
    List<String> ids = passes(), dates = new ArrayList<String>();
    for (int pass = 1; pass <= ids.size(); pass++) {
      if (dataIndex > 0 && pass != dataIndex) continue;
      String id = ids.get(pass - 1);
      dates.add(dateStamp(id));
    }
    return lastDate(dates);
  }

  void writeDateStamp(String date, String outFolder) throws UnsupportedEncodingException, IOException {
    Files.write(Paths.get(outFolder, "datestamp.isodate"), date.getBytes(StandardCharsets.UTF_8.toString()));
  }

  void datestamp(String outFolder, int dataIndex) throws Exception {
    writeDateStamp(lastUpdateDate(dataIndex), outFolder);
  }

  void convert(String outFolder, int dataIndex, boolean dump) throws Exception {
    try {
      initializeArco();
      Processor pro = new Processor(false);
      XsltCompiler xco = pro.newXsltCompiler();
      ByteArrayOutputStream baos = new ByteArrayOutputStream(), result = new ByteArrayOutputStream();
      Serializer out = pro.newSerializer(baos);
      List<String> ids = passes(), dates = new ArrayList<String>();
      int rows = 1;
      startMillis = new Date().getTime();
      String resourcePrefix = properties.getProperty("resourcePrefix", "https://w3id.org/arco/resource/Trento/").trim();
      for (int pass = 1; pass <= ids.size(); pass++) {
        if (dataIndex > 0 && pass != dataIndex) continue;
        int line = 1;
        String dataset = properties.getProperty("" + pass + ".dataset", "#" + pass);
        System.out.println("INFO - dataset " + dataset);
        String id = ids.get(pass - 1), itemPath = properties.getProperty("" + pass + ".itemId"); //System.out.println("@id " + id);
        String documentPrefix = properties.getProperty("" + pass + ".documentPrefix").trim();
        String date = dateStamp(id);
        dates.add(date); //System.out.println("INFO - update date is " + date);
        XsltTransformer xtrRdf = null, xtr = xco.compile(new StreamSource(ras(properties.getProperty("" + pass + ".xslt")))).load();
        xtr.setDestination(out);
        xtr.setParameter(new QName("datestamp"), new XdmAtomicValue(date));
        String xsltRdf = properties.getProperty("" + pass + ".2rdf.xslt");
        if (xsltRdf != null) {
          URI uri = this.getClass().getClassLoader().getResource(xsltRdf).toURI();
          converter.addXSTLConverter(uri.getScheme().equals("jar") ? Zip.open(uri).getPath(xsltRdf) : Paths.get(uri));
        }
        XPathReader reader = getPassReader(id, pass, outFolder);
        int testlines = -1;
        for (Node node; (node = reader.next()) != null; line++, rows++) {
          String itemId = null;
          try {
            itemId = safeIriPart((String) xPath.evaluate(itemPath, node, XPathConstants.STRING), "_");
            if (dump) zWrite(outFolder, itemId + ".node.xml", node2bytes(node));
            xtr.setSource(new DOMSource(node)); //System.out.println("@id " + itemId);      
            xtr.transform();
            Model model;
            byte[] ba = baos.toByteArray();
            if (dump) zWrite(outFolder, itemId + ".xml", ba);
            long start = new Date().getTime();
            try {
              model = converter.convert(itemId, resourcePrefix, documentPrefix, new ByteArrayInputStream(ba));
            } catch (Exception e) {
              writeException(outFolder, itemId, ba, line, e);
              if (testlines == line) break;
              continue;
            } finally {
              arcoMillis += new Date().getTime() - start;
            }
            if (xtrRdf != null) {
              baos.reset();
              xtrRdf.setSource(new DOMSource(node));
              xtrRdf.transform();
              Model xModel = ModelFactory.createDefaultModel();
              xModel.read(new ByteArrayInputStream(baos.toByteArray()), null, "RDF/XML");
              model.add(xModel);
            }
            model.write(result, "N-TRIPLES");
            writeContent(itemId, pass, ids.size(), line, rows, outFolder, dataIndex, result);
          } catch (Exception e) {
            writeException(outFolder, itemId, node, line, e);
          } finally {
            result.reset();
            baos.reset();
          }
          if (testlines == line) break;
        }
        System.out.println("STATUS - got " + line + " lines @dataset " + dataset);
        reader.close();
      }
      closeContent();
      writeDateStamp(lastDate(dates), outFolder);
    } finally {
      shutdownArco();
      if (zfs != null) zfs.close();
    }
  }

  static void uso() {
    System.err.println("uso: java -jar rdfTrento-0.0.1-full.jar <output folder> [-dump] [-datestamp] [-dataset:<index>]");
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
    RdfTrento rdft = new RdfTrento();
    try {
      if (datestamp)
        rdft.datestamp(outFolder, dataIndex);
      else
        rdft.convert(outFolder, dataIndex, dump);
    } catch (Throwable t) {
      fatal(outFolder, t);
    }
  }
}
