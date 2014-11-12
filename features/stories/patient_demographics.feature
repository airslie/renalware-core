Feature: Patient Demographics

  Background:
    Given there are ethnicities in the database
      And I have a patient in the database
      And that I'm logged in
      And I've searched for a patient
      And I've selected the patient from the search results

  Scenario: User views a patient's demograhics
    Then I should see the patient's demographics on their profile page

  Scenario: User updates a patient's demograhics
    When I update the patient's demographics
    Then I should see the patient's new demographics on their profile page