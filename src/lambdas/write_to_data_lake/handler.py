import boto3
import os
from datetime import datetime
import csv

TEMP_FILE_PATH = "/tmp/file.csv"

client = boto3.client("s3")


# Expected event input
# {
#     "source": "permit_system",
#     "detail": {
#         "attr1": "something else",
#         ...
#     }
# }
def handler(event, context):
    print("Started processing")
    
    f = open(TEMP_FILE_PATH, "w+")
    temp_csv = csv.writer(f)
    
    _, values = zip(*event.get("detail").items())
    
    temp_csv.writerow(values)
    
    f.close()

    client.upload_file(TEMP_FILE_PATH, os.environ.get("BUCKET_NAME"), f"{os.environ.get('DATA_LAKE_KEY')}{event.get('source')}/{datetime.now()}.csv")

    print("Processing complete")

