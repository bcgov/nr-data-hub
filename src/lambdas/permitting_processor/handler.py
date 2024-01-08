# Template example code
import boto3
import os
from datetime import datetime
import csv


client = boto3.client("s3")

TEMP_FILE_PATH = "/tmp/file.csv"
BUCKET_NAME = os.environ.get("BUCKET_NAME")
KEY = os.environ.get("KEY")

def handler(event, context):
    print("Started processing")
    
    f = open(TEMP_FILE_PATH, "w+")
    temp_csv = csv.writer(f)
    
    # TODO: Processing goes here
    
    f.close()

    file_name = "BLANK"

    client.upload_file(TEMP_FILE_PATH, BUCKET_NAME, f"{KEY}{file_name}/{datetime.now()}.csv")

    print("Processing complete")

