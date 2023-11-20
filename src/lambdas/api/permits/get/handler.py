import boto3
import os
import random
import time

client = boto3.client("athena")


# Expected event input
# {
#     "permit_system": "something",
#     "tracking_number": "something else"
# }
def handler(event, context):
    print("Starting processing")

    query = client.start_query_execution(
        QueryString = f"""SELECT * FROM "{os.environ.get("GLUE_DATABASE_NAME")}"."{event.get("permit_system")}" WHERE "trackingnumber" = '{event.get("tracking_number")}'""",
        QueryExecutionContext = {
            "Database": os.environ.get("GLUE_DATABASE_NAME")
        },
        WorkGroup = "primary",
        ResultConfiguration = { "OutputLocation": os.environ.get("ATHENA_QUERY_OUTPUT_LOCATION")}
    )

    execution_id = query.get("QueryExecutionId")

    # Exponential backoff with 5 attempts
    for i in range(5):
        # Exponential backoff sleep, at most 20 seconds
        time.sleep(min(random.random() * (2 ** i), 20))

        execution = client.get_query_execution(QueryExecutionId=execution_id)

        state = execution["QueryExecution"]["Status"]["State"]
        print(f"Status: {state}")
        if state == "SUCCEEDED":
            break

        if i == 2:
            print("ERROR: Execution unsuccessful after 5 attempts.")
            return
        
    results = client.get_query_results(
        QueryExecutionId=execution_id,
        MaxResults=2
    )

    if len(results["ResultSet"]["Rows"]) == 1:
        print("ERROR: No results returned from query.")
        return

    # TODO: Use AWS Data Wrangler lambda layer for this in the future!
    headers = [header["VarCharValue"] for header in results["ResultSet"]["Rows"][0]["Data"]]
    data = [header["VarCharValue"] for header in results["ResultSet"]["Rows"][1]["Data"]]
    types = [t["Type"] for t in results["ResultSet"]["ResultSetMetadata"]["ColumnInfo"]]

    response = dict([(header, convert(datum, types[i])) for i, (header, datum) in enumerate(zip(headers, data))])
    
    print("Processing complete")
    return response


# TODO: Remove in favour of AWS Wrangler Lambda Layer
def convert(datum, typ):
    if typ == "varchar":
        return datum
    elif typ == "double":
        return float(datum)
    elif typ == "boolean":
        return True if datum == "true" else False

