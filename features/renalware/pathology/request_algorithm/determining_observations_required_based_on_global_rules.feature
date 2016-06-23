Feature: Determining observations required based on global rules

  The global pathology algorithm determines the required observations for a patient.

  The algorithm consists of a set of global and patient rules. By applying a given parameter to a rule, the rule decides if an observation is required.

  A global rule can apply multiple parameters using different boolean logic operators:
  - if A and B then observe C
  - if A or B then observe C

  Background:
    Given Patty is a patient
    And request description BFF requires observation description B12

  @wip
  Scenario Outline: The required observations were determined based on the clinic.

     This scenario encodes the following rule as an example:

     Test for B12/FOLATE/FERRITIN (Code: BFF)
       if the patient is in Access
       and the patient was last tested a week ago or longer.

     Given the global rule sets:
       | request_description_code | BFF    |
       | clinic                   | Access |
       | frequency_type           | Always |
     When the global pathology algorithm is run for Patty in clinic <clinic>
     Then it is determined the observation is <determination>

     Examples:
       | clinic | determination |
       | Access | required      |
       | HD     | not required  |

  Scenario Outline: The required observations were determined based on the date of the last observation and the frequency.

     This scenario encodes the following rule as an example:

     Test for B12/FOLATE/FERRITIN (Code: BFF)
       if the patient is in Access
       and the patient was last tested a week ago or longer.

     Given the global rule sets:
       | request_description_code | BFF              |
       | clinic                   | Access           |
       | frequency_type           | <frequency_type> |
     And Patty was last tested for B12 <last_observed>
     When the global pathology algorithm is run for Patty in clinic Access
     Then it is determined the observation is <determination>

     Examples:
       | frequency_type | last_observed | determination |
       | Once           |               | required      |
       #| Once           | 5 days ago    | not required  |
       #| Always         |               | required      |
       #| Always         | 5 days ago    | required      |
       #| Weekly         |               | required      |
       #| Weekly         | 5 days ago    | not required  |
       #| Weekly         | 7 days ago    | required      |

  @wip
  Scenario Outline: The required observations were determined based on the date of the last observation, the frequency and a single parameter.

    This scenario encodes the following rule as an example:

    Test for B12/FOLATE/FERRITIN (Code: BFF)
      if the patient is in Access
      and the patient was last tested a week ago or longer
      and the patient has an observation result for HGB less than 100.

    Given the global rule sets:
      | request_description_code | BFF              |
      | clinic                   | Access           |
      | frequency_type           | <frequency_type> |
    And the rule set contains these rules:
      | type              | id  | operator | value |
      | ObservationResult | HGB | <        | 100   |
    And Patty has observed an HGB value of <observation_result>
    And Patty was last tested for B12 <last_observed>
    When the global pathology algorithm is run for Patty in clinic Access
    Then it is determined the observation is <determination>

    Examples:
      | frequency_type | observation_result | last_observed | determination |
      | Once           | 99                 |               | required      |
      | Once           | 100                |               | not required  |
      | Once           | 99                 | 5 days ago    | not required  |
      | Once           | 100                | 5 days ago    | not required  |

      | Always         | 99                 |               | required      |
      | Always         | 100                |               | not required  |
      | Always         | 99                 | 5 days ago    | required      |
      | Always         | 100                | 5 days ago    | not required  |

      | Weekly         | 99                 |               | required      |
      | Weekly         | 100                |               | not required  |
      | Weekly         | 99                 | 5 days ago    | not required  |
      | Weekly         | 100                | 5 days ago    | not required  |
      | Weekly         | 99                 | 7 days ago    | required      |
      | Weekly         | 100                | 7 days ago    | not required  |

  @wip
  Scenario Outline: The required observations were determined based on multiple parameters.

    Test for B12/FOLATE/FERRITIN (Code: BFF)
      if the patient is in Access
      and the patient was last tested a week ago or longer
      and the patient has an observation result for HGB less than 100
      and the patient is currently prescribed Ephedrine Tablet.

    Given the global rule sets:
      | request_description_code | BFF    |
      | clinic                   | Access |
      | frequency_type           | Always |
    And the rule set contains these rules:
      | type              | id               | operator | value |
      | ObservationResult | HGB              | <        | 100   |
      | Drug              | Ephedrine Tablet | include? |       |
    And Patty has observed an HGB value of <observation_result>
    And Patty is currently prescribed Ephedrine Tablet <drug_perscribed>
    When the global pathology algorithm is run for Patty in clinic Access
    Then it is determined the observation is <determination>

    Examples:
      | observation_result | drug_perscribed | determination |
      | 99                 | yes             | required      |
      | 99                 | no              | not required  |
      | 100                | yes             | not required  |
      | 100                | no              | not required  |

  @wip
  Scenario Outline: The required observations were determined based on the date of the last request and request expiration.

    This scenario encodes the following rule as an example:

    Test for B12/FOLATE/FERRITIN (Code: BFF)
      if the patient is in Access
      and the pathology results take up to 1 week to be received by Renalware.

    Given the request description BFF has an expiration of 7 days
    And the global rule sets:
      | request_description_code | BFF              |
      | clinic                   | Access           |
      | frequency_type           | <frequency_type> |
    And a BFF test was requested for Patty <last_requested>
    And a B12 test was observed for Patty <last_observed>
    When the global pathology algorithm is run for Patty in clinic Access
    Then it is determined the observation is <determination>

    Examples:
      | frequency_type | last_requested | last_observed | determination |
      | Always         |                |               | required      |
      | Always         | 6 days ago     |               | not required  |
      | Always         | 7 days ago     |               | required      |
      | Always         | 6 days ago     | 1 days ago    | required      |
      | Always         | 7 days ago     | 1 days ago    | required      |

      | Once           |                |               | required      |
      | Once           | 6 days ago     |               | not required  |
      | Once           | 7 days ago     |               | not required  |
      | Once           | 6 days ago     | 1 days ago    | not required  |
      | Once           | 7 days ago     | 1 days ago    | not required  |
