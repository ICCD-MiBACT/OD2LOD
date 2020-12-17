
# Regione Sardegna

Per procedere alla trasformazione dei dati provenienti da regione sardegna è necessario aver installato python3 ed aver installato e compilato il repository "rdfizer" nel progetto https://github.com/ICCD-MiBACT/ArCo.
Per poter utilizzare questo repository è necessario anche `python3` `virtualenv` e `BASH`

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