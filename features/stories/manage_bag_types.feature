Feature: An admin manages the bag_types list

  Background:
    Given that I'm logged in

    Scenario: An admin adds a new bag type to bag types list
      Given that I'm on the add a new bag type page
      When I complete the form for a bag type
      Then I should see the new bag type on the bag type list
