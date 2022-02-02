import csv
import json
from json import dump
import pandas as pd
from hdfs import InsecureClient
from google_drive_downloader import GoogleDriveDownloader as gdd


gdd.download_file_from_google_drive(file_id='1tJPOFguOVs-igoTljpPrSv00c44vuDag', dest_path='../../data/amz-toys.csv')


df = pd.read_csv('../../data/amz-toys.csv')
client = InsecureClient('http://127.0.0.1:9870', user='root')


def toHdfs(row):
   with client.write("data/file{}".format(row.name), encoding='utf-8') as writer:
      print("Write to hdfs: {}".format(row.name))
      dump(row.to_json(), writer)

df.apply(toHdfs, axis=1)
