Feature: Viewing archived pathology results for a patient

  A doctor views the archived pathology results for a patient to determine
  trends in physiological parameters over time.

  @wip
  Scenario: Multiple observation results recorded
    Given Patty is a patient
    And the following observations were recorded
      | code | result | observed_at         |
      | WBC  | 6.09   | 2009-11-11 20:26:00 |
      | RBC  | 4.00   | 2009-11-11 20:26:00 |
      | WBC  | 5.09   | 2009-11-12 10:26:00 |
      | RBC  | 3.00   | 2009-11-12 10:26:00 |
      | HB   | 2.00   | 2009-11-13 11:26:00 |
    Then the doctor views the following archived pathology result report:
      | observed_on | WBC  | HB   | RBC  |
      | 13-11-2009  |      | 2.00 |      |
      | 12-11-2009  | 5.09 |      | 3.00 |
      | 11-11-2009  | 6.09 |      | 4.00 |
