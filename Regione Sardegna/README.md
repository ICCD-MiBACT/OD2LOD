
# Regione Sardegna

Procedure per la trasformazione di [dataset pubblicati dalla Regione Sardegna](http://opendata.regione.sardegna.it/).

I contenuti dei dataset sono ricondotti dal formatio csv a modelli conformi alle normative ICCD per la rappresentazione in RDF mediante le ontologie e le trasformazioni del progetto [ArCo](https://github.com/ICCD-MiBACT/ArCo).

## requisiti

`python3` `virtualenv` e `BASH`

## Fonti e mappatura.

Le fonti utilizzate sono specificate nel file `datasets.csv`. Nello stesso file è specificata la mappatura necessaria per trasformare il CSV in un XML.

## Ottenimento e triplificazione dei dati

```BASH
#creiamo il virtualenv
virtualenv env
source env/bin/activate

#installazione delle dipendenze
pip install -r requirements.txt

# Scarico i csv e li converto in XML
python downloader.py

#Lancio la triplificazione
./triplify.sh dati-sardegna-tmp /path/di/ArCo/ArCo-release/rdfizer

# Modifico il baseURL e sostituisco gli url generati automaticamente con quelli originali
python postprocess.py dati-sardegna-tmp/dati-sardegna-tmp.nt.gz dati-sardegna.nt

deactivate
```

A questo punto l'RDF si trova nel file dati-sardegna.nt

## Controllare i risultati

Dopo la trasformazione è possibile controllare i risultati tramite il comando `check_numbers.sh`.

## Collegamento alle immagini

Nella versione più recente dei dati è stata aggiunta l'informazione per il collegamento alle immagini pubblicate sul sito della regione.

Le procedure aggiornate per la trasformazione dei nuovi dati sono raccolte nel batch toRDF.cmd.
