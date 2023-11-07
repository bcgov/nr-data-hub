import boto3
import os
from datetime import datetime
import csv

TEMP_FILE_PATH = "/tmp/file.csv"

client = boto3.client('s3')


# CSV Files are a bit odd in athena, they don't need headers? Parquet my preferred choice
def handler(event, context):
    print("Started processing")
    detail = event.get("detail")
    print(f"Event payload: {event.get('detail')}")

    f = open(TEMP_FILE_PATH, "w+")
    temp_csv = csv.writer(f)
    
    fields = [detail.get("permit_id", None), detail.get("project_id", None)]
    permit_type = detail.get("permit_type")

    if permit_type == "water":
        fields.append(detail.get("proximity_to_water", None))
    elif permit_type == "infrastructure":
        fields.append(detail.get("shares_boundary", None))
    
    temp_csv.writerow(fields)
    
    f.close()

    client.upload_file(TEMP_FILE_PATH, os.environ.get("BUCKET_NAME"), f"{os.environ.get('DATA_LAKE_KEY')}{permit_type}/{datetime.now()}.csv")

    print("Processing complete")

