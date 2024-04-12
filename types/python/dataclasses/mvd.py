# generated by datamodel-codegen:
#   filename:  mvd.schema.json
#   timestamp: 2024-04-12T18:41:00+00:00

from __future__ import annotations

from datetime import datetime
from enum import Enum
from typing import Optional
from uuid import UUID

from pydantic import BaseModel, Field


class SourceSystem(Enum):
    APTS = 'APTS'
    CATS = 'CATS'
    EPUPS__PPA = 'EPUPS; PPA'
    FTA = 'FTA'
    MOTI = 'MOTI'
    RARN = 'RARN'
    RRS = 'RRS'
    TANTALIS = 'TANTALIS'
    WILD = 'WILD'
    WMA = 'WMA'


class Agency(Enum):
    AF = 'AF'
    ENV = 'ENV'
    FOR = 'FOR'
    MOTI = 'MOTI'
    WLRS = 'WLRS'
    BCER = 'BCER'


class Business(Enum):
    Archaeology = 'Archaeology'
    Contaminated_Sites = 'Contaminated Sites'
    Lands = 'Lands'
    Riparian = 'Riparian'
    Transportation = 'Transportation'
    Water = 'Water'


class ApplicationStatus(Enum):
    Issued = 'Issued'
    Denied = 'Denied'
    Pending = 'Pending'
    In_Review = 'In Review'


class PermitApplicationName(Enum):
    Commercial_General = 'Commercial General'
    Nominal_Rent_Tenure = 'Nominal Rent Tenure'
    Residential = 'Residential'
    Roadways___Public = 'Roadways - Public'
    Utilities = 'Utilities'
    New_Groundwater_Licence = 'New Groundwater Licence'
    Water_Licence = 'Water Licence'
    Change_Approval_for_Works_in_and_About_a_Stream = (
        'Change Approval for Works in and About a Stream'
    )


class PermitApplicationType(Enum):
    New = 'New'
    Amendment = 'Amendment'
    Cancel = 'Cancel'
    Change_Ownership = 'Change Ownership'


class PermittingMvd(BaseModel):
    id: UUID = Field(..., description='Unique ID of the permit')
    application_id: UUID = Field(
        ..., description='Unique ID of the submitted application for a permit'
    )
    source_system: SourceSystem = Field(
        ..., description='Acronym for the source system providing the permit tracking'
    )
    source_system_id: UUID = Field(
        ..., description='Unique ID of the permit in the source system'
    )
    project_id: UUID = Field(
        ..., description='ID of the project this permit relates to'
    )
    agency: Agency = Field(
        ..., description='Acronym for the agency or ministry issuing the permit'
    )
    business: Business = Field(
        ..., description='Business domain or area responsible for the permit'
    )
    application_status: ApplicationStatus = Field(
        ..., description='Status of the application to obtain a permit'
    )
    permit_application_name: PermitApplicationName = Field(
        ..., description='The business domain permit type'
    )
    permit_application_type: Optional[PermitApplicationType] = Field(
        None, description='The form type for a permit or licence application'
    )
    received_date: datetime = Field(
        ..., description='Date in which the application for permit was submitted'
    )
    accepted_date: Optional[datetime] = Field(
        None,
        description="Date in which the review of the initial application's completeness concludes",
    )
    tech_review_completion_date: Optional[datetime] = Field(
        None,
        description='Date in which the technical team concludes their review of the application',
    )
    rejected_date: Optional[datetime] = Field(
        None, description='Date in which the permit is rejected'
    )
    adjudication_date: Optional[datetime] = Field(
        None, description='Date in which the permit is adjudicated, approved or issued'
    )
    amendment_date: Optional[datetime] = Field(
        None, description='Date in which the permit is amended'
    )
    fn_consultn_start_date: Optional[datetime] = Field(
        None, description='Date in which the consultation with First Nations starts'
    )
    fn_consultn_completion_date: Optional[datetime] = Field(
        None, description='Date in which the consultation with First Nations ends'
    )
