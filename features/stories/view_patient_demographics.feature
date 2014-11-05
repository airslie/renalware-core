Feature: A user views a patient's demographics

  Scenario: User views a patient's demograhics
    Given there are ethnicities in the database
      And I have a patient in the database
      And that I'm logged in
      And I've searched for a patient
      And I've selected the patient from the search results
    Then I should see the patient's demographics on their profile page