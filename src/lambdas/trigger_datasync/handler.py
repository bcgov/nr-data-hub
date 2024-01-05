import boto3
import os
import random
import time

client = boto3.client("datasync")


def handler(event, context):
    execution = client.start_task_execution(
        TaskArn=os.environ.get("TASK_ARN")
    )

    # Exponential backoff to get task execution
    for i in range(5):
        # Exponential backoff sleep, at most 20 seconds
        time.sleep(min(random.random() * (2 ** i), 20))

        execution = client.describe_task_execution(TaskExecutionArn=execution.get("TaskExecutionArn"))

        status = execution.get("Status")
        print(f"Status: {status}")
        if status == "SUCCESS":
            result = execution.get("Result", {})
            error_code = result.get("ErrorCode")
            error_detail = result.get("ErrorDetail")
            if error_code or error_detail:
                print(f"{error_code}: {error_detail}")
            return
        
    