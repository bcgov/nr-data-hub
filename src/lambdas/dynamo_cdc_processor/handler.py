import boto3
import json
import os
from datetime import datetime

client = boto3.client("events")


def handler(event, context):
    print("Processing Started")
    
    entries = []

    for record in event.get("Records"):
        event_name = record.get("eventName")
        if event_name == "INSERT":
            entries.append(get_insert_event(record))
        elif event_name == "MODIFY":
            entries.append(get_modify_event(record))
        else:
            print(f"ERROR: Unhandled record eventName: {event_name}")
            return

    response = client.put_events(
        Entries=entries)
    if response["FailedEntryCount"]:
        print(f"ERROR: Failed to publish events. Response: {response}")
    print("Processing Completed")


def get_insert_event(record):
    tracking_number = record["dynamodb"]["Keys"]["trackingnumber"]
    new_image = record["dynamodb"]["NewImage"]

    new_image.pop("trackingnumber")

    permit_system, value = list(new_image.items())[0]

    return {
        "Time": datetime.fromtimestamp(record["dynamodb"]["ApproximateCreationDateTime"]),
        "Source": permit_system,
        "Resources": [],
        "DetailType": "Project Added",
        "Detail": json.dumps({
            "notification": f'Project added with trackingnumber {tracking_number.get("S")}',
            "message": f'Inception Permit System {permit_system}. Current Status {value.get("S")}'
        }),
        "EventBusName": os.environ["EventBusName"],
    }


def get_modify_event(record):
    tracking_number = record["dynamodb"]["Keys"]["trackingnumber"]
    new_image = record["dynamodb"]["NewImage"]
    old_image = record["dynamodb"]["OldImage"]

    event = {
        "Time": datetime.fromtimestamp(record["dynamodb"]["ApproximateCreationDateTime"]),
        "Source": "PLACEHOLDER",
        "Resources": [],
        "DetailType": "PLACEHOLDER",
        "Detail": {},
        "EventBusName": os.environ["EventBusName"],
    }

    if len(list(new_image.keys())) != len(list(old_image.keys())):
        new_system = (set(new_image) - set(old_image)).pop()
        event["Source"] = new_system
        event["DetailType"] = "Permit Added to Project"
        event["Detail"] = json.dumps({
            "notification": f'Permit added to Project with trackingnumber {tracking_number.get("S")}',
            "message": f'System: {new_system}. Current Status: {new_image[new_system].get("S")}'
        })
        return event
    else:
        system = ""
        new_status = ""
        old_status = ""
        for key in list(new_image.keys()):
            if new_image[key] != old_image[key]:
                system = key
                new_status = new_image[key].get("S")
                old_status = old_image[key].get("S")
                break
        event["Source"] = system
        event["DetailType"] = "Permit Status Changed"
        event["Detail"] = json.dumps({
            "notification": f'Permit updated on project with trackingnumber {tracking_number.get("S")}',
            "message": f'System: {system}. Current Status: {new_status}. Previous Status: {old_status}'
        })
        return event

