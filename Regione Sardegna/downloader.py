import csv
import requests
import json
import xmltodict
import os
import re
import hashlib 
import shutil

if os.path.exists('csv'):
    shutil.rmtree('csv')
os.makedirs('csv')

if os.path.exists('xml'):
    shutil.rmtree('xml')
os.makedirs('xml')

nctn2url = {}

def CSV_to_dict(data, mapping_file):
    # reading mapping
    mapping = json.load(open('mapping/' + mapping_file))

    # quickfix to give items an ID
    #print(data['NCTN'])

    if 'LATITUDINE' in data.keys():
        if data['LATITUDINE'] != '':
            data['LATITUDINE'] = re.sub(r'[^0-9\.]', '', data['LATITUDINE'])
    
    if 'LONGITUDINE' in data.keys():
        if data['LONGITUDINE'] != '':
            data['LONGITUDINE'] = re.sub(r'[^0-9\.]', '', data['LONGITUDINE'])
            if data['LONGITUDINE'].find('.') == 2:
                data['LONGITUDINE'], data['LATITUDINE'] = data['LATITUDINE'], data['LONGITUDINE']
            
    data['NCTR'] = '20'

    obj = dict()
    for key, value in data.items():
        if value == '':
            continue
        if len(mapping) > 0:
            data = obj
            while len(mapping[key]):
                part = mapping[key].pop(0)
                if len(mapping[key]) == 0:
                    data[part] = value
                    break
                
                if part not in data.keys():
                    data[part] = {}
                    data = data[part]
                else:
                    data = data[part]
    return obj

def handle_CSV(csv_file, mapping_file, nctn2url):

    # reading csv
    with open(csv_file, mode="r", encoding="utf-8") as csv_data:
        csv_data_reader = csv.DictReader(csv_data)

        previous_NCTN = ''
        counter = ''

        for data_row in csv_data_reader:
            
            if data_row['NCTN'] == '':
                data_row['NCTN'] = hashlib.md5(''.join(data_row.values()).encode()).hexdigest()

            if data_row['NCTN'] == previous_NCTN:
                data_row['NCTN'] += "-" + str(counter)
                counter += 1
            else:
                counter = 1

            convert_obj = CSV_to_dict(data_row, mapping_file)

            previous_NCTN = data_row['NCTN']

            base_filename = mapping_file.split('.')[0]
            base_dir = './xml/' + base_filename

            if not os.path.exists(base_dir):
                os.makedirs(base_dir)
            xml_file_name = base_dir + '/' + base_filename + '-' + data_row['NCTN'] + '.xml'
            with open(xml_file_name, mode='w', encoding="utf-8") as w:
                w.write(xmltodict.unparse(convert_obj, pretty=True))

            if 'URL' in data_row.keys() and data_row['URL'] != '':
                nctn2url[data_row['NCTN']] = data_row['URL']


with open('datasets.csv') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        
        print('asking from', row['url'])
        r = requests.get(row['url'])
        csv_name = 'csv/' + row['mapping'].split('.')[0] + '.csv'
        
        print('saving file', csv_name)

        with open(csv_name, 'wb') as f:
            f.write(r.content)
        
        handle_CSV(csv_name, row['mapping'], nctn2url)

with open('nctn2url.json' ,'w') as json_file:
    json.dump(nctn2url, json_file)