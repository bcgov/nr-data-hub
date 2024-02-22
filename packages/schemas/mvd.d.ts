/* eslint-disable */
/**
 * This file was automatically generated.
 * DO NOT MODIFY IT BY HAND.
 */

/**
 * Standardisation of the attributes collected from all LOB source systems associated with the PMT
 */
export interface PermittingMvd {
  /**
   * Unique ID of the permit
   */
  id: string;
  /**
   * Unique ID of the submitted application for a permit
   */
  application_id: string;
  /**
   * Acronym for the source system providing the permit tracking
   */
  source_system: "APTS" | "CATS" | "EPUPS; PPA" | "FTA" | "MOTI" | "RARN" | "RRS" | "TANTALIS" | "WILD" | "WMA";
  /**
   * Unique ID of the permit in the source system
   */
  source_system_id: string;
  /**
   * ID of the project this permit relates to
   */
  project_id: string;
  /**
   * Acronym for the agency or ministry issuing the permit
   */
  agency: "AF" | "ENV" | "FOR" | "MOTI" | "WLRS" | "BCER";
  /**
   * Business domain or area responsible for the permit
   */
  business: "Archaeology" | "Contaminated Sites" | "Lands" | "Riparian" | "Transportation" | "Water";
  /**
   * Status of the application to obtain a permit
   */
  application_status: "Issued" | "Denied" | "Pending" | "In Review";
  /**
   * The business domain permit type
   */
  permit_application_name:
    | "Commercial General"
    | "Nominal Rent Tenure"
    | "Residential"
    | "Roadways - Public"
    | "Utilities"
    | "New Groundwater Licence"
    | "Water Licence"
    | "Change Approval for Works in and About a Stream";
  /**
   * The form type for a permit or licence application
   */
  permit_application_type?: "New" | "Amendment" | "Cancel" | "Change Ownership";
  /**
   * Date in which the application for permit was submitted
   */
  received_date: string;
  /**
   * Date in which the review of the initial application's completeness concludes
   */
  accepted_date?: string;
  /**
   * Date in which the technical team concludes their review of the application
   */
  "tech_review_completion_date "?: string;
  /**
   * Date in which the permit is rejected
   */
  rejected_date?: string;
  /**
   * Date in which the permit is adjudicated, approved or issued
   */
  "adjudication_date "?: string;
  /**
   * Date in which the permit is amended
   */
  amendment_date?: string;
  /**
   * Date in which the consultation with First Nations starts
   */
  fn_consultn_start_date?: string;
  /**
   * Date in which the consultation with First Nations ends
   */
  fn_consultn_completion_date?: string;
}
