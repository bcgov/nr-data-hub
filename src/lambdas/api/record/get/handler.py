import boto3
import os
import random
import time

client = boto3.client("athena")


def handler(event, context):
    print("Starting processing")
    
    permit_type = event.get("permit_type", None)
    if not permit_type:
        raise Exception("permit_type missing from request body")
    permit_id = event.get("permit_id", None)
    if not permit_id:
        raise Exception("permit_id missing from request body")

    query = client.start_query_execution(
        QueryString = f"""SELECT * FROM "{os.environ.get("GLUE_DATABASE_NAME", None)}"."{permit_type}" WHERE "permit_id" = '{permit_id}'""",
        QueryExecutionContext = {
            "Database": os.environ.get("GLUE_DATABASE_NAME", None)
        },
        WorkGroup = "primary",
        ResultConfiguration = { "OutputLocation": os.environ.get("ATHENA_QUERY_OUTPUT_LOCATION", None)}
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
            raise Exception("Execution unsuccessful after 5 attempts.")
        
    results = client.get_query_results(
        QueryExecutionId=execution_id,
        MaxResults=2
    )

    if len(results["ResultSet"]["Rows"]) == 1:
        raise Exception("No results returned from query.")

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

