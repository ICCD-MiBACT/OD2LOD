import gzip
import sys
import json
import re
from urllib.parse import urlparse

fileName = sys.argv[1]
outfile = sys.argv[2]

def uri_validator(x):
    try:
        result = urlparse(x)
        return all([result.scheme, result.netloc, result.path])
    except:
        return False

#with open('nctn2url.json') as f:
#    nctn2url = json.load(f)

with open(outfile, mode='w+', encoding="utf-8") as out:
    with gzip.open(fileName, mode='rt', encoding="utf-8") as f:
        for line in f:
            #
            # unneeded code
            #  baseURL => rdfizer command line
            #  dc:source => xtra.xslt
            #
            ## Changing baseURL
            #line = re.sub(r'<https://w3id.org/arco/resource/', '<https://w3id.org/arco/resource/SARDEGNA/', line)
            #
            ## Changing baseURI 
            #if " <http://purl.org/dc/elements/1.1/source> " in line:
            #    nctns = re.search('<https://w3id.org/arco/resource/SARDEGNA/[^/]+/([a-zA-Z0-9]+)>.*', line)
            #    if nctns:
            #        nctn = nctns.group(1)
            #        #print(nctn)
            #        components = line.split(' ')
            #        if len(components) == 4:
            #            if nctn in nctn2url.keys() and nctn2url[nctn]:
            #                if uri_validator(nctn2url[nctn]):
            #                    components[2] = "<" + nctn2url[nctn] + ">"
            #                    line = ' '.join(components)
            #                    out.write(line)
            #elif '<https://w3id.org/italia/onto/CLV/Address> .' in line:
            
            # unneeded code
            #  PVCR => region
            #if '<https://w3id.org/italia/onto/CLV/Address> .' in line:
            #    out.write(line.split(' ')[0] + ' <https://w3id.org/italia/onto/CLV/hasRegion> <https://w3id.org/arco/resource/Region/sardegna> .')
            #    out.write('\n' + line)
            #else:
                out.write(line)