import boto3
import json
import os

client = boto3.client("dynamodb")


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

    detail = event.get("detail")
    trackingnumber = detail.pop("trackingnumber")
    permit_system = event.get("source")

    attribute_updates = {permit_system: {"Value": {"S": detail.get("status")}}}

    _ = client.update_item(
        TableName=os.environ["DYNAMODB_TABLE_NAME"],
        Key={"trackingnumber": {
            "S": trackingnumber,
        }},
        AttributeUpdates=attribute_updates,
        ReturnValues="NONE"
    )

    print("Processing complete")


