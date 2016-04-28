@wip
Feature: Updating a patient

  When the address of a patient changes, the pending letters (not archived)
  must be refreshed with the new address.

  Background:
    Given Nathalie is a nurse
    And Patty is a patient
    And Patty is the main recipient on a pending letter

  Scenario: A nurse updated the patient's address
    When Nathalie updates Patty's address
    Then Patty's pending letter is addressed to her new address
