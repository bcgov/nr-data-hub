from jsonschema import validate
import json
import sys


def validate_schema(input_file: str, target_schema_file: str) -> None:
    with open(input_file) as f:
        schema = json.load(f)

    with open(target_schema_file) as f:
        target_schema = json.load(f)

    validate(schema, target_schema)


if __name__ == "__main__":
    validate_schema(sys.argv[0], sys.argv[1])
