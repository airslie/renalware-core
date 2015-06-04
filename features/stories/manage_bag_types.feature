Feature: An admin manages the bag_types list

  Background:
    Given that I'm logged in

    Scenario: An admin adds a new bag type to bag types list
      Given that I'm on the add a new bag type page
      When I complete the form for a bag type
      Then I should see the new bag type on the bag type list

    Scenario: An admin edits a saved bag type to bag types list
      Given that I have saved bag types
        And that I choose to edit a bag type
      When I complete the form for editing a bag type
      Then I should see the updated bag type on the bag types list
