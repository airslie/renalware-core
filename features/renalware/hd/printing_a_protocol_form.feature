Feature: Printing a protocol

  A nurse prints out an HD Protocol for a patient so he can use it to record
  HD observations.

  @wip
  Scenario: A nurse views the patient's HD protocol before printing it
    Given Nathalie is a nurse
    And Patty is a patient
    And Patty has a recorded HD profile
    And Patty has these recorded HD Sessions
    When Natalie views the protocol
    Then the protocol contains
      | some            | data         | or other??    |
