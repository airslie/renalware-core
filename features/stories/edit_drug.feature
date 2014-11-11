Feature: An admin edits a drug in the drugs list

  Scenario: An admin edits a drug in the drugs list
    Given that I'm logged in
      And there are drugs in the database
      And that I choose to edit a drug
    When I complete the form for editing a drug
    Then I should see the updated drug on the drugs list