import boto3
import os

client = boto3.client("dynamodb")


# Expected event input
# {
#     "tracking_number": "something"
# }
def handler(event, context):
    print("Processing Started")

    tracking_number = event.get("tracking_number")

    response = client.get_item(
        Key={"trackingnumber": {"S": tracking_number}},
        TableName=os.environ["DYNAMODB_TABLE_NAME"]
    )
    
    print("Processing Completed")
    return {k: v.get("S") for k, v in response.get("Item", {}).items() if k != "trackingnumber"}

