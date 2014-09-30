Feature: Hello World 

Scenario: Page echoes Hello World
  Given I am on the hello world page
  Then I should see "Hello World"

Scenario: Form displays age
  Given I am on the hello world page
  When I fill in the form with my age
    And submit the form 
  Then I should see my age displayed on the page 