Feature: User Sign In Feature
@wip
  Scenario: User login
    Given I have a user in the database
      And I am on the signin page
    When I sign in
    Then I should see my dashboard