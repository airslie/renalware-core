Feature: An admin adds a new drug to the drugs list
@wip
  Scenario: An admin adds a new drug to the drugs list 
    Given that I'm logged in
      And that I'm on the add a new drug page
    When I complete the form for a new drug
    Then I should see the new drug on the drugs list
     