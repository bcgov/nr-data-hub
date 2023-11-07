import boto3
import os
import json
from datetime import datetime

events_client = boto3.client("events")
glue_client = boto3.client("glue")

VALID_DOMAINS = ["Permitting"]

def handler(event, context):
    print("Starting Processing")

    domain = event.get("domain", None)
    if not domain:
        raise Exception("Provide a domain name.")
    
    table = event.get("table", None)
    if not domain:
        raise Exception("Provide a table name.")
    
    attributes = event.get("attributes", None)
    if not attributes:
        raise Exception("Provide attributes.")
    
    if not is_valid_domain(domain):
        raise Exception(f"Invalid domain name: {domain}")

    # Hardcoded for no good reason
    tables = glue_client.get_tables(DatabaseName="nr-event-based-data-permitting-kane").get("TableList", [])

    if not is_valid_table(table, tables):
        raise Exception(f"Invalid table name: {table}")

    validate_attributes(attributes, table, tables)

    response = events_client.put_events(
        Entries=[
            {
                "Time": datetime.now(),
                "Source": context.invoked_function_arn,
                "Resources": [],
                "DetailType": domain,
                "Detail": json.dumps({
                    "permit_type": table,
                    **attributes
                }),
                "EventBusName": os.environ["EventBusName"],
            }
        ])
    if response["FailedEntryCount"]:
        raise Exception(f"Failed to publish event. Response: {response}")
    print("Successfully published to EventBridge")
    print("Processing Complete")


def is_valid_domain(domain):
    return domain in VALID_DOMAINS


def is_valid_table(table, tables):
    return table in [t["Name"] for t in tables]


# Basic validation to check required fields are there
def validate_attributes(attributes, table, tables):
    columns = []
    for t in tables:
        if t["Name"] == table:
            columns = t["StorageDescriptor"]["Columns"]
    
    if not columns:
        raise Exception("Table columns not found")
    
    required_columns = set(c["Name"] for c in columns if c["Parameters"].get("required", "false") == "true")

    if not required_columns.issubset(attributes):
        raise Exception(f"Missing required columns: {required_columns}")
    

