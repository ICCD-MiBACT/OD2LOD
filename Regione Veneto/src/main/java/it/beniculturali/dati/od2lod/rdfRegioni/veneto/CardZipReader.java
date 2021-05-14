package it.beniculturali.dati.od2lod.rdfRegioni.veneto;

import java.io.IOException;
import java.nio.file.FileSystem;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

class CardZipReader extends Zip { 
 private FileSystem fs;
 private int index = 0; // next resource index
 private String name; // last resource name
 private List<String>names;
 private List<Path>paths;
 public CardZipReader(FileSystem fs, List<String>names) throws IOException{
  this.fs = fs; this.names = names;
  if (names==null) { paths = list(fs);
   System.out.println("zip folder has " + paths.size() + " files");
  }
 }
 public byte[]next() throws IOException {
  Path f = null;
  if (names!=null) {
   if (index>=names.size()) return null;
   name = names.get(index++);
   f = fs.getPath("/", name);
  }
  else {
   if (index>=paths.size()) return null;
   f = paths.get(index++);
   name = f.getFileName().toString();
  }
  return Files.readAllBytes(f);
 }
 public String name() {return name;}
 public void close() {}
}