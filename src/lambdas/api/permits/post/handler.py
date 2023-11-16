import boto3
import os
import json
from datetime import datetime

client = boto3.client("events")


# Expected event input
# {
#     "permit_system": "something",
#     "attributes": {
#         "attr1": "something else",
#         ...
#     }
# }
def handler(event, context):
    print("Processing Started")
    response = client.put_events(
        Entries=[
            {
                "Time": datetime.now(),
                "Source": event.get("permit_system"),
                "Resources": [],
                "DetailType": "domain",
                "Detail": json.dumps({
                    **event.get("attributes")
                }),
                "EventBusName": os.environ["EventBusName"],
            }
        ])
    if response["FailedEntryCount"]:
        raise Exception(f"Failed to publish event. Response: {response}")
    print("Processing Complete")

