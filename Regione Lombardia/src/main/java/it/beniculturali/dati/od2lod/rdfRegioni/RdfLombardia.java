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
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import java.util.TreeSet;
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
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;
import org.mapdb.DB;
import org.mapdb.DBMaker;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import it.cnr.istc.stlab.arco.Converter;
import it.cnr.istc.stlab.arco.preprocessing.PreprocessedData;
import it.cnr.istc.stlab.arco.preprocessing.Preprocessor;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.Serializer;
import net.sf.saxon.s9api.XdmAtomicValue;
import net.sf.saxon.s9api.XsltCompiler;
import net.sf.saxon.s9api.XsltTransformer;

public class RdfLombardia {
 private DocumentBuilder db;
 private Transformer nullTransformer;
 RdfLombardia() throws IOException, TransformerConfigurationException, TransformerFactoryConfigurationError, ParserConfigurationException { 
  db = DocumentBuilderFactory.newInstance().newDocumentBuilder();
  loadProperties(); nullTransformer = TransformerFactory.newInstance().newTransformer(); }
 InputStream ras(String s) { return this.getClass().getClassLoader().getResourceAsStream(s); }
 Properties properties = new Properties();
 void loadProperties() throws IOException {
  InputStream is = ras("rdfLombardia.properties");
  properties.load(is);
  is.close();
 } 
 static String safeIriPart(String s, String replacer) {
  String pattern = "[^" +
   "-A-Za-z0-9\\._~" +          
   "\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF" +
   "\u10000-\u1FFFD\u20000-\u2FFFD\u30000-\u3FFFD" +
   "\u40000-\u4FFFD\u50000-\u5FFFD\u60000-\u6FFFD" +
   "\u70000-\u7FFFD\u80000-\u8FFFD\u90000-\u9FFFD" +
   "\uA0000-\uAFFFD\uB0000-\uBFFFD\uC0000-\uCFFFD" +
   "\uD0000-\uDFFFD\uE1000-\uEFFFD" +
   "]";
  return s.replaceAll(pattern, replacer);
 }
 static void fatal(String outFolder, Throwable t) throws UnsupportedEncodingException, FileNotFoundException {
  String filename = "" + new Date().getTime() + ".exception"; System.err.println("ERROR - Exception " + t + " written to " + filename);
  PrintStream ps = new PrintStream(new FileOutputStream(new File(outFolder, filename)), false, StandardCharsets.UTF_8.toString());
  t.printStackTrace(ps); ps.close();
 }
 byte[] document2bytes(Document d) throws TransformerException { ByteArrayOutputStream os = new ByteArrayOutputStream(); nullTransformer.transform(new DOMSource(d), new StreamResult(os)); return os.toByteArray(); }
 void writeDocument(File f, Document d) throws TransformerException { nullTransformer.transform(new DOMSource(d), new StreamResult(f)); }
 private void writeException(String outFolder, String id, Document row, int line, Exception e) throws Exception { if (id==null) throw(e);
  String filename = "offending_row_" + id + ".xml"; System.err.println("ERROR - Exception " + e + " caught @row " + line + " written to " + filename);
  writeDocument(new File(outFolder, filename), row);
 }
 static void writeContent(File f, byte[]c) throws IOException { FileOutputStream fos = new FileOutputStream(f); fos.write(c); fos.close(); }
 private void writeException(String outFolder, String id, byte[]content, int line, Exception e) throws Exception {
  String filename = "offending_node_" + id + ".xml"; System.err.println("ERROR - Exception " + e + " caught @row " + line + " written to " + filename);
  writeContent(new File(outFolder, filename), content);  
 }
 static DecimalFormat df = new DecimalFormat("0.0"), df7 = new DecimalFormat("0000000");
 int lastStartRow = 0;
 int rowCountFlush = 12 * 1024;
 private BufferedOutputStream bos = null;
 private void closeContent() throws IOException { if (bos!=null) {bos.flush(); bos.close(); bos = null;} }
 private void flushContent(int rows, String outFolder, byte[]content) throws IOException {
  if (lastStartRow==0 || rows-lastStartRow>=rowCountFlush) { if (bos!=null) closeContent();
   String filename = "arco-knowledge-graph-1.0_R03_" + df7.format(rows) + ".nt.gz";
   System.out.println("STATUS - writing @" + filename);
   bos = new BufferedOutputStream(new GZIPOutputStream(new FileOutputStream(new File(outFolder, filename),false)));
   lastStartRow = rows;
  }
  /*
  String lines[] = new String(content, StandardCharsets.UTF_8.toString()).split(lineSplitter);
  Set<String>xlines = new HashSet<String>(1024);
  for (String line:lines) xlines.add(line);
  xlines = new TreeSet<String>(xlines); // sort
  Iterator<String>it = xlines.iterator(); 
  while (it.hasNext()) { bos.write(it.next().getBytes(StandardCharsets.UTF_8.toString())); bos.write('\n'); }
  */
  bos.write(content);
 }
 long startMillis;
 static final String lineSplitter = "\\r\\n|\\n|\\r";
 static String writePercentage(long n, long d) { return d>0 ? "" + df.format(n * 100. / d) + "%" : "0"; }
 static String writeRate(long n, long md){if (md==0) return ""; return "@" + df.format(n*1000./md) + " rows/sec";}
 private void writeContent(int pass, int csvLine, int rows, String outFolder, ByteArrayOutputStream result) throws IOException { flushContent(rows, outFolder, result.toByteArray());
  if ((rows%2048)==0) { long now=new Date().getTime(); System.out.println("STATUS - got "+rows+" rows "+writeRate(rows, now-startMillis)+" (arco " + writePercentage(arcoMillis, now-startMillis)+")"); }
 } 
 static FileSystem zfs = null; 
 @SuppressWarnings("serial") static FileSystem zfs(String outFolder) throws IOException {if (zfs==null) zfs = FileSystems.newFileSystem(URI.create("jar:" + new File(outFolder, "dump.zip").toURI()), new HashMap<String, String>() {{ put("create", "true"); }}); return zfs;};
 static void zWrite(String outFolder, String name, byte[]content) throws IOException { 
  Files.write(zfs(outFolder).getPath(name), content, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING, StandardOpenOption.WRITE); // jre 1.8 bug: needs explicit option
}
 @SuppressWarnings("unchecked") void addMap(DB db, String name) {db.hashMap(name).keySerializer(org.mapdb.Serializer.STRING).valueSerializer(org.mapdb.Serializer.JAVA).createOrOpen();}
 void checkDbData() { if (new File(PreprocessedData.dbFileName).exists()) return;
 DB db = DBMaker.fileDB(PreprocessedData.dbFileName).make();
 addMap(db, "ftan2URL"); addMap(db, "catalogueRecordIdentifier2URI"); addMap(db, "uniqueIdentifier2URIs");
 db.commit(); db.close();
}
 private Converter converter = null;
 private Preprocessor preprocessor = null;
 void initializeArco() throws MalformedURLException, IOException { checkDbData(); converter = new Converter(); /* preprocessor = new Preprocessor(".", ".", "https://w3id.org/arco/resource/"); */ }
 void shutdownArco() { if (preprocessor!=null) {preprocessor.commit(); preprocessor.close();} if (converter!=null) converter.destroy(); }
 void updateArco(Document d) throws XPathExpressionException { preprocessor.preprocessDomRecord(d); }
 long arcoMillis = 0;
 String toIsoDate(String s){ String[]a = s.split("/"); return (a[2].length()==2?"20":"") + a[2] + "-" + (a[1].length()<2?"0":"") + a[1] + "-" + (a[0].length()<2?"0":"") + a[0]; }
 List<String>passes() { List<String>result = new ArrayList<String>(); for (int j=1;;j++) { String id = properties.getProperty("" + j + ".id"); if (id==null) break; result.add(id); } return result; }
 private XPath xPath = XPathFactory.newInstance().newXPath();
 String rawDateStamp(String id) throws XPathExpressionException, MalformedURLException, SAXException, IOException {
  return (String)xPath.evaluate(properties.getProperty("datePath").replaceAll("\\$\\(id\\)", id),db.parse(new URL(properties.getProperty("dateDocument").replaceAll("\\$\\(id\\)", id)).openStream()));
 }
 String lastDate(List<String>dates) { String result = null; for (String date:dates) if (result == null || result.compareTo(date)<0) result = date; return result; }
 String lastUpdateDate() throws XPathExpressionException, MalformedURLException, SAXException, IOException {
  List<String>ids = passes(), dates = new ArrayList<String>(); for (String id:ids) dates.add(toIsoDate(rawDateStamp(id))); 
  return lastDate(dates);
 }
 void writeDateStamp(String date, String outFolder) throws UnsupportedEncodingException, IOException { Files.write( Paths.get(outFolder,"datestamp.isodate"), date.getBytes(StandardCharsets.UTF_8.toString())); }
 void datestamp(String outFolder) throws XPathExpressionException, MalformedURLException, SAXException, IOException { writeDateStamp(lastUpdateDate(), outFolder); }
 void convert(String outFolder, boolean dump) throws Exception { try { initializeArco(); 
  String csv = properties.getProperty("csv");
  Processor pro = new Processor(false); XsltCompiler xco = pro.newXsltCompiler();
  ByteArrayOutputStream baos = new ByteArrayOutputStream(); Serializer out = pro.newSerializer(baos);
  ByteArrayOutputStream result = new ByteArrayOutputStream(); int rows = 1; startMillis = new Date().getTime();
  List<String>ids = passes(), dates = new ArrayList<String>(); 
  for (int pass=1; pass<=ids.size(); pass++) { String id = ids.get(pass-1); //System.out.println("@id " + id);
   String csvUrl = csv.replaceAll("\\$\\(id\\)", id), itemPath = properties.getProperty("" + pass + ".itemId");
   XsltTransformer xtrRdf = null, xtr = xco.compile(new StreamSource(ras(properties.getProperty("" + pass + ".xslt")))).load();
   xtr.setDestination(out);
   String date = toIsoDate(rawDateStamp(id)); dates.add(date);
   xtr.setParameter(new QName("datestamp"), new XdmAtomicValue(date));
   String xsltRdf = properties.getProperty("" + pass + ".2rdf.xslt");
   if (xsltRdf!=null) { System.out.println("xsltRdf: " + xsltRdf);
    xtrRdf = xco.compile(new StreamSource(ras(xsltRdf))).load();
    xtrRdf.setDestination(out);   
   }
   System.out.println("STATUS - reading @" + csvUrl); int line=1;
   CsvRow2domReader r2d = new CsvRow2domReader(csvUrl, properties.getProperty("" + pass + ".splitter"), properties.getProperty("" + pass + ".split"), true);
   for (Document row;(row=r2d.next())!=null;line++,rows++) { String itemId = null;
    try { itemId = safeIriPart((String)xPath.evaluate(itemPath, row, XPathConstants.STRING),"_");
     //row2rdf(itemId, row, itemPath, xtr, xtrRdf, baos, result, outFolder, line, dump);     
     if (dump) zWrite(outFolder, itemId + ".csv2.xml", document2bytes(row));
     xtr.setSource(new DOMSource(row)); //System.out.println("@id " + itemId);      
     xtr.transform(); Model model; byte[]ba = baos.toByteArray();
     if (dump) zWrite(outFolder, itemId + ".xml", ba);
     long start = new Date().getTime();
     try { //updateArco(db.parse(new ByteArrayInputStream(ba)));
      model = converter.convert(itemId, new ByteArrayInputStream(ba)); }
     catch (Exception e) { writeException(outFolder, itemId, ba, line, e); continue; }
     finally { arcoMillis += new Date().getTime() - start; }
     if (xtrRdf!=null) {
      baos.reset();
      xtrRdf.setSource(new DOMSource(row));       
      xtrRdf.transform();
      Model xModel = ModelFactory.createDefaultModel();
      xModel.read(new ByteArrayInputStream(baos.toByteArray()), null, "RDF/XML");
      model.add(xModel);     
     }
     model.write(result, "N-TRIPLES");     
     writeContent(pass, line, rows, outFolder, result);
    }
    catch(Exception e) { writeException(outFolder, itemId, row, line, e); }
    finally { result.reset(); baos.reset(); }
    //if (line==2) break; // test
   }
   r2d.close();
  }
  closeContent();
  writeDateStamp(lastDate(dates), outFolder);
 } finally { shutdownArco(); if (zfs!=null) zfs.close(); }}
 static void uso() { System.err.println("uso: java -jar rdfLombardia-0.0.1-full.jar <output folder> [-dump] [-datestamp]"); System.exit(-1); }
 public static void main(String[] args) throws Exception { if (args.length<1) uso();
  String outFolder = args[0]; boolean datestamp = false, dump = false;;  
  for (int j=1; j<args.length; j++) {
   if (args[j].compareTo("-datestamp")==0) { datestamp = true; continue; }
   if (args[j].compareTo("-dump")==0) { dump = true; continue; }
   uso();
  }
  RdfLombardia rdfl = new RdfLombardia(); 
  try { if (datestamp) rdfl.datestamp(outFolder); else rdfl.convert(outFolder, dump); }
  catch (Throwable t) { fatal(outFolder, t); }
 }
}
