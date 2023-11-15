import boto3
import os
import json
from datetime import datetime

client = boto3.client("events")


def handler(event, context):
    print("Starting Processing")

    response = client.put_events(
        Entries=[
            {
                "Time": datetime.now(),
                "Source": context.invoked_function_arn,
                "Resources": [],
                "DetailType": "Permitting Status Changed",
                "Detail": json.dumps({
                    "application_id": "1",
                    "permit_id": "2",
                    "old_status": "In Progress",
                    "new_status": "Complete",
                }),
                "EventBusName": os.environ["EventBusName"],
            }
        ])
    if response["FailedEntryCount"]:
        raise Exception(f"Failed to publish event. Response: {response}")
    print("Successfully published to EventBridge")
    print("Processing Complete")

