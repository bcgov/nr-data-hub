# Data Collection Template

In an effort to homogenize the collection, presentation and integration of data with downstream consumers, this template has been put together for the PMT to better indicate the data that is required. Data integration has been separated into 4 key sections:

- Access
  - Involves identifying stakeholders associated with the data and granting IDT access to data sources and integration tools to ensure participation in the integration process.
- Data Discovery
  - Involves identifying and cataloging the available data sources, understanding their structures, formats, and relationships, and determining their suitability for integration.
- Validation
  - Involves the extraction of data from the identified sources using various methods such as APIs, database queries, or file transfers, and then validating it to ensure accuracy, consistency, and completeness before further processing.
- Integration
  - Involves designing and implementing data pipelines that automate the movement, transformation, and loading of data from source systems to target destinations to ensure efficient and reliable integration.

Each of the sections details the step by step process to follow, with data that needs to be documented. Fields _italicized_ are the key pieces of information that need to be recorded at each stage. Use the data integration schema to record this information programmatically to enhance its consumability.

## Access

- Identify the LOB system on the IRS portal
  - Record the _source_system_ acronym of the LOB
  - Record the _agency_ responsible for the LOB system
  - Record the _business_ responsible for the LOB system
  - Record the _description_ of the LOB system
- Identify key contacts and stakeholders associated with the source systems
  - Record the _data_custodian_, _data_specialist_, and/or _data_owner_ fields associated with the source system, ensuring the _contact_name_ and _contact_email_ fields are correct for each
- Request the necessary access required to complete the following steps by contacting the contacts identified above

## Data Discovery

- Create an understanding of the LOB process
  - Create a simple workflow diagram illustrating the authorization process
  - **TBD: Can we define this using the schema?**
- Describe the dataset
  - Record the _technology_ fields, ensuring the _name_ and _version_ are correct
  - Record the _security_classification_ for the entire dataset
- Record the _storage_descriptor_ fields, which provides a description of the dataset at a column granularity. For each column, record the following:
  - Record the _column_name_ field
  - Record the _type_ field
  - Record the _precision_ field
  - Record the _description_ field
  - Record the _security_classification_ field
  - Record the _nullable_ field

## Validation

- Validate the extraction query with the LOB data custodians, specialists and/or owners
  - Record this query in the _extraction_query_ field, escaping the string as required
- Conduct an assessment of the completeness and quality of the data provided by the LOB system, recording the collected information in the _data_quality_metrics_ fields
  - Record the _accuracy_ field, allowing us to assess just how trustworthy the dataset is (TBD)
  - Record the _completeness_ field, allowing us to assess how complete the dataset is
  - Record the _timeliness_ field, the frequency at which data in the source system is updated or refreshed, expressed in minutes
  - Record the _duplication_ field, the percentage of values in the data set that are duplicated
- Record the _column_mapping_ fields, which maps the source systems columns to those of the MVD
  - For each column, record the source system column name as the key and the mapped mvd field as the value

## Integration

Integration is an automated step, facilitated by the accurate collection of data throughout discovery. Some information is as follows:

- _security_classification_ of the dataset dictates whether integration can take place in the cloud, or has to be on-premise
  - Protected C data has to remain on-premise
  - Preference should be to strive for cloud based integration for Protected A and Protected B data, and on-premise integration for Protected C
- _technology_ fields dictate the method for ingestion
  - Integration for Oracle based systems can make use of the _nr-oracle-service_ application
  - **TBD: Integration for other database systems is under investigation**
- _storage_descriptor_ fields dictate data lake and relational database structure
  - Column information is mapped to complementary data types for the cloud based storage
- _data_quality_metrics_ fields are used to automatically create data quality checks and supported monitoring infrastructure
- All remaining information is used to populate further information for the LOB in the metadata catalog