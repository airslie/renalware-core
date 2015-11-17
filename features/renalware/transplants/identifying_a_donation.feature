@wip
Feature: Identifying a donation

  A patient can act as a living donor for another patient.  The possible donation
  is first recorded.  It is then assigned to a potential recipient.

  Rules:

  - the recipient does not have to be known at the time of the recording
  - if a donation is found unsuitable for a recipient, additional donations can be recorded
    for other recipients

  Background:
    And Clyde is a clinician
    And Don is a patient

  @web
  Scenario: A clinician recorded a donation for a live donor
    When Clyde records a donation for Don
    Then Don has a new donation

  @web
  Scenario: A clinician updated a donation of a live donor
    Given Don has a donation
    Then Clyde can update Don's donation

  @web
  Scenario: A clinician submitted an erroneous donation for a live donor
    When Clyde submits an erroneous donation
    Then the donation is not accepted
