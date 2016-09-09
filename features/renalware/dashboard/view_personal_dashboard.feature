Feature: View a personal dashboard

  The personal dashboard presents pertinent information to the current system user:
  - draft letters the user is currently typing
  - letters pending review by the user
  - patients the user has bookmarked

  Background:
    Given Nathalie is a nurse
    And Doug is a doctor
    And Patty is a patient

  @web
  Scenario: The system user was drafting a letter (i.e the typist)
    Given Nathalie drafted a letter for Patty
    Then Patty's draft letter is accessible from Nathalie's dashboard

  @web
  Scenario: The system user is an author of a letter pending review
    Given Nathalie drafted a letter for Patty on behalf of Doug
    And Nathalie submitted the letter for review
    Then Patty's pending letter is accessible from Doug's dashboard

  @web
  Scenario: The system user bookmarked a patient
    Given Doug bookmarked Patty
    Then Patty is accessible from Doug's dashboard
