Feature: Viewing historical pathology observation results for a patient

  A doctor views the most recent pathology observation results for a patient to
  determine trends in physiological parameters over time.

  @wip @web
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
    Then the doctor views the following historical observation results:
      | date        | HGB  | MCV  | WBC  |
      | 13-11-2009  |      |      | 2.00 |
      | 12-11-2009  | 5.09 | 3.00 |      |
      | 11-11-2009  | 6.09 | 4.00 |      |
