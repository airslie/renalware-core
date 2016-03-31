Feature: Viewing archived pathology results for a patient

  A doctor views the archived pathology results for a patient to determine
  trends in physiological parameters over time.

  @web
  Scenario: Multiple observation results recorded
    Given Patty is a patient
    And Nathalie is a nurse
    And the following observations were recorded
      | code | result | observed_at         |
      | HGB  | 6.09   | 2009-11-11 12:00:00 |
      | MCV  | 4.00   | 2009-11-11 12:00:00 |
      | HGB  | 5.09   | 2009-11-12 12:00:00 |
      | MCV  | 3.00   | 2009-11-12 12:00:00 |
      | WBC  | 2.00   | 2009-11-13 12:00:00 |
    Then the doctor views the following archived pathology result report:
      | year | 2009  | 2009  | 2009  |
      | date | 13/11 | 12/11 | 11/11 |
      | HGB  |       | 5.09  | 6.09  |
      | MCV  |       | 3.00  | 4.00  |
      | WBC  | 2.00  |       |       |
      | AL   |       |       |       |
