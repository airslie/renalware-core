Feature: An admin manages the drugs list

  Background:
    Given that I'm logged in
      And there are drugs in the database
      And there are ethnicities in the database
      And I have a patient in the database

    Scenario: An admin adds a new drug to the drugs list   
      Given that I'm on the add a new drug page
      When I complete the form for a new drug
      Then I should see the new drug on the drugs list

    Scenario: An admin edits a drug in the drugs list
      Given that I choose to edit a drug
      When I complete the form for editing a drug
      Then I should see the updated drug on the drugs list
    @wip
    Scenario: An admin soft deletes a drug in the drugs list
      Given I am on the drugs index
      When I choose to soft delete a drug
      Then I should see the drug removed from the drugs list
       And I should see the patient medication using removed drug to be terminated from active medications