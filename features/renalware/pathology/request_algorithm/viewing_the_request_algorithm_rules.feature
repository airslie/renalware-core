Feature: Viewing the request algorithm rules

  The rules that determine which request_description observation is required to made for a
  patient are stored in the database.

  A user views the rules written in plain English which are displayed an a table.

  @web
  Scenario: A user views the rules for the request algorithm

    This scenario encodes the following rule as an example:

    Test for B12/FOLATE/FERRITIN (Code: BFF)
      if the patient is in Haemodialysis
      and the patient was last tested a week ago or longer
      and the patient has an observation result for HGB less than 100.
      and the patient is currently prescribed Ephedrine Tablet.

    Test for MALARIA (Code: MAL)
      if the patient is in Transplant
      and the patient was last tested a week ago or longer

    Given Clyde is a clinician
    And the global rule sets:
      | request_description_code | MAL           |
      | clinic                   | Transplant    |
      | frequency_type           | Monthly       |
    And the global rule sets:
      | request_description_code | BFF           |
      | clinic                   | Haemodialysis |
      | frequency_type           | Weekly        |
    And the rule set contains these rules:
      | type              | id               | operator | value |
      | ObservationResult | HGB              | <        | 100   |
      | PrescriptionDrug  | Ephedrine Tablet | include? |       |
    When the request algorithm rules are viewed by clyde
    Then clyde see rules for these request_descriptions and clinics:
     | request_description_code | clinic        |
     | BFF                      | Haemodialysis |
     | MAL                      | Transplant    |
