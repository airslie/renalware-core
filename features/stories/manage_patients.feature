Feature: A secretary manages patients

  Background:
    Given that I'm logged in
      And there are ethnicities in the database

    Scenario: Secretary adds a new patient
      Given I am on the add a new patient page
      When I complete the add a new patient form
      Then I should see the new patient in the Renal Patient List
        And the patient should be created

    @elasticsearch
    Scenario: User views a patient's demographics
      Given I have a patient in the database
        And I am on the patients list
      When I search for a patient by first name
        And I've selected the patient from the search results
      Then I should see the patient's demographics on their profile page

    @elasticsearch
    Scenario: User updates a patient's demographics
      Given I have a patient in the database
        And I am on the patients list
      When I search for a patient by first name
        And I've selected the patient from the search results
        And I update the patient's demographics
      Then I should see the patient's new demographics on their profile page