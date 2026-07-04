package it.beniculturali.dati.od2lod.rdfRegioni.bolzano;

import java.io.InputStream;
import java.net.URL;

public class Resource {
  public URL getUrl(String name) {
    URL result;
    result = Resource.class.getClassLoader().getResource(name);
    if (result == null && !name.startsWith("/")) {
      result = Resource.class.getClassLoader().getResource("./" + name);
      if (result == null) result = Resource.class.getClassLoader().getResource("/" + name);
      if (result == null) System.err.println("getUrl() failed on '" + name + "'");
    }//if (result!=null) System.out.println("getUrl() succeded on '" + name + "'");
    return result;
  }

  public InputStream getStream(String fileName) {
    InputStream result;
    result = Resource.class.getClassLoader().getResourceAsStream(fileName);
    if (result == null && !fileName.startsWith("/")) {
      result = Resource.class.getClassLoader().getResourceAsStream("./" + fileName);
      if (result == null) result = Resource.class.getClassLoader().getResourceAsStream("/" + fileName);
      if (result == null) System.err.println("getStream() failed on '" + fileName + "'");
    }//if (result!=null) System.out.println("getStream() succeded on '" + fileName + "'");
    return result;
  }
}
