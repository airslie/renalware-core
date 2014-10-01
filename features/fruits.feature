Feature: Legacy Database feature

  Scenario: A user sees some fruits
    Given the legacy database data "fruits.ddl"
      And I have some fruits
      And I am on the fruits dashboard
    When I view all fruits
    Then I should see a list of fruits
