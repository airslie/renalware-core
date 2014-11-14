Feature: An admin soft deletes a drug in the drugs list

  Scenario: An admin soft deletes a drug in the drugs list
    Given that I'm logged in
      And there are drugs in the database
      And I am on the drugs index
    When I choose to soft delete a drug
    Then I should see the drug removed from the drugs list