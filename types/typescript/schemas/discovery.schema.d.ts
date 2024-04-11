/* eslint-disable */
/**
 * This file was automatically generated.
 * Do not modify this file by hand.
 */

/**
 * Data custodian(s) of the dataset
 */
export type Users = {
  /**
   * Name of the user
   */
  name: string;
  /**
   * Email of the user
   */
  email: string;
}[];
/**
 * Data owner(s) of the dataset
 */
export type Users1 = {
  /**
   * Name of the user
   */
  name: string;
  /**
   * Email of the user
   */
  email: string;
}[];
/**
 * Data specialist(s) of the dataset
 */
export type Users2 = {
  /**
   * Name of the user
   */
  name: string;
  /**
   * Email of the user
   */
  email: string;
}[];

/**
 * Metadata collected during data discovery
 */
export interface DataDiscoverySchema {
  /**
   * Acronym for the source system providing the data, as it is defined in IRS
   */
  source_system: string;
  /**
   * Acronym for the agency or ministry that owns the dataset
   */
  agency: string;
  /**
   * Business domain or area responsible for the data
   */
  business: string;
  data_custodian: Users;
  data_owner?: Users1;
  data_specialist?: Users2;
  /**
   * Quantified information pertaining to the quality of the data observed in the dataset.
   */
  data_quality_metrics: {
    /**
     * Percentage of correct values in the dataset compared to the total number of values.
     */
    accuracy?: number;
    /**
     * Percentage of missing values in the dataset.
     */
    completeness?: number;
    /**
     * Frequency at which data is updated or refreshed to reflect the most recent information, expressed in minutes.
     */
    timeliness?: number;
    /**
     * Percentage of duplicated records in the dataset.
     */
    duplication?: number;
  };
  /**
   * Description of the dataset
   */
  description: string;
  /**
   * Security classification of the dataset
   */
  security_classification: "Protected A" | "Protected B" | "Protected C";
  /**
   * Description of the underlying technology of the dataset
   */
  technology: {
    /**
     * Name of the technology
     */
    name: string;
    /**
     * Version of the technology
     */
    version: string;
  };
  /**
   * Tags of the dataset, defined as key-value pairs
   */
  tags?: {
    key: string;
    value: string;
  }[];
  /**
   * Categories to define the dataset
   */
  categories?: string[];
  /**
   * Relational data storage description at a table granularity
   */
  storage_descriptor: {
    /**
     * Name of the table as it is defined in the source database
     */
    table_name: string;
    /**
     * Name of the schema as it is defined in the source database
     */
    schema_name: string;
    /**
     * Relational data storage description at a column granularity
     *
     * @minItems 1
     */
    columns: [
      {
        /**
         * Column name
         */
        name: string;
        /**
         * Column data type
         */
        type: string;
        /**
         * Precision of the column (optional)
         */
        precision?: string;
        /**
         * Description of the column
         */
        description: string;
        /**
         * Security classification of the column
         */
        security_classification: "Protected A" | "Protected B" | "Protected C";
        /**
         * Flag to indicate if the column is nullable
         */
        nullable: boolean;
      },
      ...{
        /**
         * Column name
         */
        name: string;
        /**
         * Column data type
         */
        type: string;
        /**
         * Precision of the column (optional)
         */
        precision?: string;
        /**
         * Description of the column
         */
        description: string;
        /**
         * Security classification of the column
         */
        security_classification: "Protected A" | "Protected B" | "Protected C";
        /**
         * Flag to indicate if the column is nullable
         */
        nullable: boolean;
      }[]
    ];
  }[];
  /**
   * Object mapping source system columns as defined in the storage_descriptor to those of the MVD. Each key should have the form 'schema_name.table_name.column'
   */
  column_mapping: {};
  /**
   * Extraction query used to retrieve target data from the source system
   */
  extraction_query: string;
  /**
   * Graph representation of the flowchart
   */
  flowchart?: {
    /**
     * Zero indexed root node of the flowchart
     */
    root: number;
    /**
     * Nodes of the flowchart
     */
    nodes: string[];
    /**
     * Representation of each edge in the flowchart, including direction and textual information to display
     */
    edges: {
      /**
       * Index of the origin node of the edge in the flowchart, zero-indexed
       */
      origin_node: number;
      /**
       * Index of the destination node of the edge in the flowchart, zero-indexed
       */
      destination_node: number;
      /**
       * Textual information to display on the edge of the flowchart
       */
      text: string;
    }[];
  };
}
