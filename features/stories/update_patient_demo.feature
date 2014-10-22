Feature: A user updates a patient's demographics
@wip
  Scenario: User updates a patient's demograhics
    Given I have a patient in the database
      And that I'm logged in
      And I've searched for a patient
      And I've selected the patient from the search results
    When I update the patient's demographics 
    Then I should see the patient's new demographics on their profile page