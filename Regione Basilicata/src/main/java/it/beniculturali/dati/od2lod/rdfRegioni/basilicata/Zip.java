package it.beniculturali.dati.od2lod.rdfRegioni.basilicata;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.nio.file.DirectoryStream;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class Zip { // flat zip filesystem
 static List<Path>list(FileSystem fs) throws IOException { List<Path>result = new ArrayList<Path>();
  Iterable<Path> dirs = fs.getRootDirectories();
  for (Path dir: dirs) { DirectoryStream<Path> stream = Files.newDirectoryStream(dir);
   for (Path file: stream) result.add(file);
  }
  return result;
 }
 static void close(FileSystem fs) throws IOException { if (fs!=null) fs.close(); }
 @SuppressWarnings("serial") static FileSystem create(String outFolder, String name) throws IOException { return FileSystems.newFileSystem(URI.create("jar:" + new File(outFolder, name + ".zip").toURI()), new HashMap<String, String>() {{ put("create", "true"); }}); }
 static FileSystem open(File z) throws IOException { return FileSystems.newFileSystem(URI.create("jar:" + z.toURI()), new HashMap<String, String>()); }
 static FileSystem open(URI uri) throws IOException { return FileSystems.newFileSystem(uri, new HashMap<String, String>()); }
 static void write(FileSystem fs, String name, byte[]content) throws IOException { Files.write(fs.getPath(name), content, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING, StandardOpenOption.WRITE); } // jre 1.8 bug: needs explicit option}
 static byte[]bytes(FileSystem fs, String name) throws IOException { Path f = fs.getPath("/", name); if (!Files.exists(f)) return null; return Files.readAllBytes(f); }
}
