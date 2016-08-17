Feature: Determining observations required based on the frequency

  Both Pathology algorithms define the frequency of a rule for determining if the test is required
  for a patient. The frequency type of a rule states how long ago the rule's observation must have
  been observed on in order for the test to be required. These are the frequency types used:

  | Frequency    | When is an observation required?       |
  | Always       | Every time a request form is generated |
  | Weekly       | Last result observed on > 5 days ago   |
  | Monthly      | Last result observed on > 28 days ago  |
  | TwoMonthly   | Last result observed on > 60 days ago  |
  | ThreeMonthly | Last result observed on > 90 days ago  |
  | FourMonthly  | Last result observed on > 120 days ago |
  | SixMonthly   | Last result observed on > 180 days ago |
  | Yearly       | Last result observed on > 360 days ago |

  Background:
    Given Patty is a patient
    And request description BFF requires observation description B12

  Scenario Outline: The required observations were determined based on the date of the last observation and the frequency.

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
       | Once           | 5 days ago    | not required  |
       | Always         |               | required      |
       | Always         | 5 days ago    | required      |
       | Weekly         |               | required      |
       | Weekly         | 5 days ago    | not required  |
       | Weekly         | 6 days ago    | required      |
       | Monthly        |               | required      |
       | Monthly        | 28 days ago   | not required  |
       | Monthly        | 29 days ago   | required      |
       | TwoMonthly     |               | required      |
       | TwoMonthly     | 60 days ago   | not required  |
       | TwoMonthly     | 61 days ago   | required      |
       | ThreeMonthly   |               | required      |
       | ThreeMonthly   | 90 days ago   | not required  |
       | ThreeMonthly   | 91 days ago   | required      |
       | FourMonthly    |               | required      |
       | FourMonthly    | 120 days ago  | not required  |
       | FourMonthly    | 121 days ago  | required      |
       | SixMonthly     |               | required      |
       | SixMonthly     | 180 days ago  | not required  |
       | SixMonthly     | 181 days ago  | required      |
       | Yearly         |               | required      |
       | Yearly         | 360 days ago  | not required  |
       | Yearly         | 361 days ago  | required      |
