Feature: Identifying a donation

  A patient can act as a living donor for another patient, the recipient.  The possible donation
  is first recorded.  It is then assigned to a potential recipient.

  Rules:

  - the recipient does not have to be known at the time of the recording
  - if a donation is found unsuitable for a recipient, additional donations can be recorded
    for that donor

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

  @web @javascript
  Scenario: A clinician assigned a recipient to a donation
    Given Don has a donation
    And Patty is a patient
    When Clyde assigns Patty as a recipient for Don's donation
    Then the donation has Patty as a recipient
