import boto3
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

    trackingnumber = event.get("detail").get("trackingnumber")
    permit_system = event.get("source")
    attribute_updates = {f"{permit_system}_{k}": {"Value": {"S": v}} for k, v in event.get("detail").items() if v != "trackingnumber"}

    response = client.update_item(
        TableName=os.environ["DYNAMODB_TABLE_NAME"],
        Key={"trackingnumber": {
            "S": trackingnumber,
        }},
        AttributeUpdates=attribute_updates,
        ReturnValues="NONE"
    )

    print("Processing complete")


