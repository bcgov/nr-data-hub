## permitting\_mvd Type

`object` ([permitting\_mvd](mvd.md))

# permitting\_mvd Properties

| Property                                                       | Type     | Required | Nullable       | Defined by                                                                                                                                                                        |
| :------------------------------------------------------------- | :------- | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [id](#id)                                                      | `string` | Required | cannot be null | [permitting\_mvd](mvd-properties-id.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/id")                                                   |
| [application\_id](#application_id)                             | `string` | Required | cannot be null | [permitting\_mvd](mvd-properties-application_id.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/application_id")                           |
| [source\_system](#source_system)                               | `string` | Required | cannot be null | [permitting\_mvd](mvd-properties-source_system.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/source_system")                             |
| [source\_system\_id](#source_system_id)                        | `string` | Required | cannot be null | [permitting\_mvd](mvd-properties-source_system_id.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/source_system_id")                       |
| [project\_id](#project_id)                                     | `string` | Required | cannot be null | [permitting\_mvd](mvd-properties-project_id.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/project_id")                                   |
| [agency](#agency)                                              | `string` | Required | cannot be null | [permitting\_mvd](mvd-properties-agency.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/agency")                                           |
| [business](#business)                                          | `string` | Required | cannot be null | [permitting\_mvd](mvd-properties-business.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/business")                                       |
| [application\_status](#application_status)                     | `string` | Required | cannot be null | [permitting\_mvd](mvd-properties-application_status.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/application_status")                   |
| [permit\_application\_name](#permit_application_name)          | `string` | Required | cannot be null | [permitting\_mvd](mvd-properties-permit_application_name.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/permit_application_name")         |
| [permit\_application\_type](#permit_application_type)          | `string` | Optional | can be null    | [permitting\_mvd](mvd-properties-permit_application_type.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/permit_application_type")         |
| [received\_date](#received_date)                               | `string` | Required | cannot be null | [permitting\_mvd](mvd-properties-received_date.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/received_date")                             |
| [accepted\_date](#accepted_date)                               | `string` | Optional | can be null    | [permitting\_mvd](mvd-properties-accepted_date.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/accepted_date")                             |
| [tech\_review\_completion\_date](#tech_review_completion_date) | `string` | Optional | can be null    | [permitting\_mvd](mvd-properties-tech_review_completion_date.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/tech_review_completion_date") |
| [rejected\_date](#rejected_date)                               | `string` | Optional | can be null    | [permitting\_mvd](mvd-properties-rejected_date.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/rejected_date")                             |
| [adjudication\_date](#adjudication_date)                       | `string` | Optional | can be null    | [permitting\_mvd](mvd-properties-adjudication_date.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/adjudication_date")                     |
| [amendment\_date](#amendment_date)                             | `string` | Optional | can be null    | [permitting\_mvd](mvd-properties-amendment_date.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/amendment_date")                           |
| [fn\_consultn\_start\_date](#fn_consultn_start_date)           | `string` | Optional | can be null    | [permitting\_mvd](mvd-properties-fn_consultn_start_date.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/fn_consultn_start_date")           |
| [fn\_consultn\_completion\_date](#fn_consultn_completion_date) | `string` | Optional | can be null    | [permitting\_mvd](mvd-properties-fn_consultn_completion_date.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/fn_consultn_completion_date") |

## id

Unique ID of the permit

`id`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [permitting\_mvd](mvd-properties-id.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/id")

### id Type

`string`

### id Constraints

**UUID**: the string must be a UUID, according to [RFC 4122](https://tools.ietf.org/html/rfc4122 "check the specification")

## application\_id

Unique ID of the submitted application for a permit

`application_id`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [permitting\_mvd](mvd-properties-application_id.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/application_id")

### application\_id Type

`string`

### application\_id Constraints

**UUID**: the string must be a UUID, according to [RFC 4122](https://tools.ietf.org/html/rfc4122 "check the specification")

## source\_system

Acronym for the source system providing the permit tracking

`source_system`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [permitting\_mvd](mvd-properties-source_system.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/source_system")

### source\_system Type

`string`

### source\_system Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value          | Explanation                     |
| :------------- | :------------------------------ |
| `"APTS"`       | TODO: Add enum description here |
| `"CATS"`       | TODO: Add enum description here |
| `"EPUPS; PPA"` | TODO: Add enum description here |
| `"FTA"`        | TODO: Add enum description here |
| `"MOTI"`       | TODO: Add enum description here |
| `"RARN"`       | TODO: Add enum description here |
| `"RRS"`        | TODO: Add enum description here |
| `"TANTALIS"`   | TODO: Add enum description here |
| `"WILD"`       | TODO: Add enum description here |
| `"WMA"`        | TODO: Add enum description here |

## source\_system\_id

Unique ID of the permit in the source system

`source_system_id`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [permitting\_mvd](mvd-properties-source_system_id.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/source_system_id")

### source\_system\_id Type

`string`

### source\_system\_id Constraints

**UUID**: the string must be a UUID, according to [RFC 4122](https://tools.ietf.org/html/rfc4122 "check the specification")

## project\_id

ID of the project this permit relates to

`project_id`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [permitting\_mvd](mvd-properties-project_id.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/project_id")

### project\_id Type

`string`

### project\_id Constraints

**UUID**: the string must be a UUID, according to [RFC 4122](https://tools.ietf.org/html/rfc4122 "check the specification")

## agency

Acronym for the agency or ministry issuing the permit

`agency`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [permitting\_mvd](mvd-properties-agency.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/agency")

### agency Type

`string`

### agency Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value    | Explanation                     |
| :------- | :------------------------------ |
| `"AF"`   | TODO: Add enum description here |
| `"ENV"`  | TODO: Add enum description here |
| `"FOR"`  | TODO: Add enum description here |
| `"MOTI"` | TODO: Add enum description here |
| `"WLRS"` | TODO: Add enum description here |
| `"BCER"` | TODO: Add enum description here |

## business

Business domain or area responsible for the permit

`business`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [permitting\_mvd](mvd-properties-business.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/business")

### business Type

`string`

### business Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value                  | Explanation                     |
| :--------------------- | :------------------------------ |
| `"Archaeology"`        | TODO: Add enum description here |
| `"Contaminated Sites"` | TODO: Add enum description here |
| `"Lands"`              | TODO: Add enum description here |
| `"Riparian"`           | TODO: Add enum description here |
| `"Transportation"`     | TODO: Add enum description here |
| `"Water"`              | TODO: Add enum description here |

## application\_status

Status of the application to obtain a permit

`application_status`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [permitting\_mvd](mvd-properties-application_status.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/application_status")

### application\_status Type

`string`

### application\_status Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value         | Explanation                     |
| :------------ | :------------------------------ |
| `"Issued"`    | TODO: Add enum description here |
| `"Denied"`    | TODO: Add enum description here |
| `"Pending"`   | TODO: Add enum description here |
| `"In Review"` | TODO: Add enum description here |

## permit\_application\_name

The business domain permit type

`permit_application_name`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [permitting\_mvd](mvd-properties-permit_application_name.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/permit_application_name")

### permit\_application\_name Type

`string`

### permit\_application\_name Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value                                               | Explanation                     |
| :-------------------------------------------------- | :------------------------------ |
| `"Commercial General"`                              | TODO: Add enum description here |
| `"Nominal Rent Tenure"`                             | TODO: Add enum description here |
| `"Residential"`                                     | TODO: Add enum description here |
| `"Roadways - Public"`                               | TODO: Add enum description here |
| `"Utilities"`                                       | TODO: Add enum description here |
| `"New Groundwater Licence"`                         | TODO: Add enum description here |
| `"Water Licence"`                                   | TODO: Add enum description here |
| `"Change Approval for Works in and About a Stream"` | TODO: Add enum description here |

## permit\_application\_type

The form type for a permit or licence application

`permit_application_type`

*   is optional

*   Type: `string`

*   can be null

*   defined in: [permitting\_mvd](mvd-properties-permit_application_type.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/permit_application_type")

### permit\_application\_type Type

`string`

### permit\_application\_type Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value                | Explanation                     |
| :------------------- | :------------------------------ |
| `"New"`              | TODO: Add enum description here |
| `"Amendment"`        | TODO: Add enum description here |
| `"Cancel"`           | TODO: Add enum description here |
| `"Change Ownership"` | TODO: Add enum description here |

## received\_date

Date in which the application for permit was submitted

`received_date`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [permitting\_mvd](mvd-properties-received_date.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/received_date")

### received\_date Type

`string`

### received\_date Constraints

**date time**: the string must be a date time string, according to [RFC 3339, section 5.6](https://tools.ietf.org/html/rfc3339 "check the specification")

## accepted\_date

Date in which the review of the initial application's completeness concludes

`accepted_date`

*   is optional

*   Type: `string`

*   can be null

*   defined in: [permitting\_mvd](mvd-properties-accepted_date.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/accepted_date")

### accepted\_date Type

`string`

### accepted\_date Constraints

**date time**: the string must be a date time string, according to [RFC 3339, section 5.6](https://tools.ietf.org/html/rfc3339 "check the specification")

## tech\_review\_completion\_date

Date in which the technical team concludes their review of the application

`tech_review_completion_date`

*   is optional

*   Type: `string`

*   can be null

*   defined in: [permitting\_mvd](mvd-properties-tech_review_completion_date.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/tech_review_completion_date")

### tech\_review\_completion\_date Type

`string`

### tech\_review\_completion\_date Constraints

**date time**: the string must be a date time string, according to [RFC 3339, section 5.6](https://tools.ietf.org/html/rfc3339 "check the specification")

## rejected\_date

Date in which the permit is rejected

`rejected_date`

*   is optional

*   Type: `string`

*   can be null

*   defined in: [permitting\_mvd](mvd-properties-rejected_date.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/rejected_date")

### rejected\_date Type

`string`

### rejected\_date Constraints

**date time**: the string must be a date time string, according to [RFC 3339, section 5.6](https://tools.ietf.org/html/rfc3339 "check the specification")

## adjudication\_date

Date in which the permit is adjudicated, approved or issued

`adjudication_date`

*   is optional

*   Type: `string`

*   can be null

*   defined in: [permitting\_mvd](mvd-properties-adjudication_date.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/adjudication_date")

### adjudication\_date Type

`string`

### adjudication\_date Constraints

**date time**: the string must be a date time string, according to [RFC 3339, section 5.6](https://tools.ietf.org/html/rfc3339 "check the specification")

## amendment\_date

Date in which the permit is amended

`amendment_date`

*   is optional

*   Type: `string`

*   can be null

*   defined in: [permitting\_mvd](mvd-properties-amendment_date.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/amendment_date")

### amendment\_date Type

`string`

### amendment\_date Constraints

**date time**: the string must be a date time string, according to [RFC 3339, section 5.6](https://tools.ietf.org/html/rfc3339 "check the specification")

## fn\_consultn\_start\_date

Date in which the consultation with First Nations starts

`fn_consultn_start_date`

*   is optional

*   Type: `string`

*   can be null

*   defined in: [permitting\_mvd](mvd-properties-fn_consultn_start_date.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/fn_consultn_start_date")

### fn\_consultn\_start\_date Type

`string`

### fn\_consultn\_start\_date Constraints

**date time**: the string must be a date time string, according to [RFC 3339, section 5.6](https://tools.ietf.org/html/rfc3339 "check the specification")

## fn\_consultn\_completion\_date

Date in which the consultation with First Nations ends

`fn_consultn_completion_date`

*   is optional

*   Type: `string`

*   can be null

*   defined in: [permitting\_mvd](mvd-properties-fn_consultn_completion_date.md "https://github.com/bcgov/nr-data-hub/tree/main/schemas/mvd.schema.json#/properties/fn_consultn_completion_date")

### fn\_consultn\_completion\_date Type

`string`

### fn\_consultn\_completion\_date Constraints

**date time**: the string must be a date time string, according to [RFC 3339, section 5.6](https://tools.ietf.org/html/rfc3339 "check the specification")
