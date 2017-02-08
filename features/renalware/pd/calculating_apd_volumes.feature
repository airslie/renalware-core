Feature: The system calculates apd volumes after a clinician has saved an APD regime

  Background:
    Given Clyde is a clinician
      And Patty is a patient

  # A patient on APD with wet day using a 5L 1.36%, a 5L 2.27%, a 2 L Nutrineal bag and a 2L
  # Extraneal for a 1.5 last fill on 6 nights per week. They are doing 6 exchanges of 2L with 80%
  # tidal and Full drain ON. So the total potential fluid available for overnight exchanges is
  # 12L (5 + 5 + 2) and the actual exchanged vol is 10.4L (2 + 1.6 + 1.6 + 2 + 1.6 + 1.6).
  # Therefore (((5 x 6)/12)x10.4)/7 = 3.71L of 1.36%.
  # The 2.27% volume used in this example would be the same.
  Scenario: APD Wet Day Tidal
    When Clyde creates the following APD Regime for Patty
    | argument                          | value |
    | fill_volume                       | 2000 |
    | last_fill_volume                  | 1500 |
    | additional_manual_exchange_volume | 1000 |
    | cycles | 6 |
    | start_date | 01-May-2016 |
    | tidal_indicator | true |
    | tidal_percentage | 80 |
    | tidal_full_drain_every_three_cycles | true |
    And adds the following bags
    | glucose_content | name                                        | volume | days                                                     | role       |
    | 1.36            | Baxter Dianeal PD2 1.36% (Yellow)           | 5000   | monday,tuesday,wednesday,thursday,friday,saturday | ordinary   |
    | 2.27            | Baxter Dianeal PD2 2.27% (Green)            | 5000   | monday,tuesday,wednesday,thursday,friday,saturday | ordinary   |
    | 0               | Baxter Nutrineal PD4 (Blue)                 | 2000   | monday,tuesday,wednesday,thursday,friday,saturday | ordinary  |
    | 0               | Baxter Extraneal (Icodextrin 7.5%) (Purple) | 2000   | monday,tuesday,wednesday,thursday,friday,saturday | last_fill  |
    Then the calculated regime volumes are
    | name                        | volume  |
    | overnight_volume            | 10400   |
    | glucose_volume_percent_1_36 | 3714    |
    | glucose_volume_percent_2_27 | 3714    |
    | glucose_volume_percent_3_86 | 0       |

  # APD wet day with an additional manual exchange of 2 L 1.36%. All the bags are being used 7 days
  # per week and each night the patient has a 5L 1.36% bag, a 5L 2.27% bag, a 2 L Nutrineal
  # (no glucose)- (so total volume available overnight is 12L. There is a last fill of Extraneal
  # (no glucose) 2L and an additional manual exchange of 1.36% 2L. Patient is tidal 80% with full
  # fill every third cycle, 6 cycles in total of 2 L - therefore Actual Overnight volume is
  # 10.4 L (2 + 1.6 + 1.6 + 2 + 1.6 + 1.6).
  # Therefore, for the 1.36% volume, we have
  # (((5000 x 7)/12)x 10.4)/7 = 4333.33
  # and
  # (2000 x 7)/7 = 2000 which is the additional manual exchange which happens each day.
  # So average 1.36% use per day is 4333.33 + 2000 = 6333.33
  # For the 2.27% the equation is
  # (((5000 x 7)/12)x 10.4)/7 = 4333.33 (this is of course the same as the above equation for the
  # overnight 1.36% bag as, for this regime, the overnight 1.36% and 2.27% bags are the same \
  # volume and frequency).
  Scenario: APD Wet Day Tidal with additional manual exchange
    When Clyde creates the following APD Regime for Patty
    | argument                            | value       |
    | fill_volume                         | 2000        |
    | last_fill_volume                    | 1500        |
    | additional_manual_exchange_volume   | 2000        |
    | cycles                              | 6           |
    | start_date                          | 01-May-2016 |
    | tidal_indicator                     | true        |
    | tidal_percentage                    | 80          |
    | tidal_full_drain_every_three_cycles | true        |
    And adds the following bags
    | glucose_content    | name                                        | volume | days                                                     | role                        |
    | 1.36               | Baxter Dianeal PD2 1.36% (Yellow)           | 5000   | monday,tuesday,wednesday,thursday,friday,saturday,sunday | ordinary                    |
    | 2.27               | Baxter Dianeal PD2 2.27% (Green)            | 5000   | monday,tuesday,wednesday,thursday,friday,saturday,sunday | ordinary                    |
    | 0                  | Baxter Nutrineal PD4 (Blue)                 | 2000   | monday,tuesday,wednesday,thursday,friday,saturday,sunday | ordinary                    |
    | 0                  | Baxter Extraneal (Icodextrin 7.5%) (Purple) | 2000   | monday,tuesday,wednesday,thursday,friday,saturday,sunday | last_fill                   |
    | 1.36               | Baxter Dianeal PD2 1.36% (Yellow)           | 5000   | monday,tuesday,wednesday,thursday,friday,saturday,sunday | additional_manual_exchange  |
    Then the calculated regime volumes are
    | name                        | volume |
    | daily_volume                | 13900  |
    | overnight_volume            | 10400  |
    | glucose_volume_percent_1_36 | 6333   |
    | glucose_volume_percent_2_27 | 4333   |
    | glucose_volume_percent_3_86 | 0      |

  # A patient on APD with wet day and an additional manual exchange using
  # - 5L 1.36% 7 nights per week
  # - another 5L 1.36% on 5 nights per week
  # - a 5L 2.27% bag on the other 2 nights per week
  # - 2L Nutrineal
  # - a 5L Extraneal with a 2L last fill and a
  # - 5L 1.36% bag using 2L as the Additional Manual Exchange 7 days per week.
  # 6 exchanges of 2L volume with no Tidal. So the total volume
  # available for overnight exchange is 12L and the actual exchanged volume is also 12 L (6 x 2).
  # Therefore
  # - First 5L 1.36% bag, equation is (((5 x 7)/12)x12)/7 = 5L
  # - Second 5L 1.36% bag, equation is (((5 x 5)/12) x 12)/7 = 3.57 (only uses the second bag on
  #   5 nights per week)
  # Additional Manual 1.36% equation is ((2 x 7)/7 = 2L
  # So average daily 1.36% use is 5 + 3.57 + 2 = 10.571L
  # In this example, the 2.27% bag use equation is
  # (((5 x 2)/12) x 12)/7 = 1.428L. Another way of thinking of this is the patient uses
  # two 5L 2.27% bags each week so 10L in total therefore 10/7 litres each day.
  Scenario: APD Wet Day Tidal with additional manual exchange
    When Clyde creates the following APD Regime for Patty
    | argument                            | value       |
    | fill_volume                         | 2000        |
    | last_fill_volume                    | 2000        |
    | additional_manual_exchange_volume   | 2000        |
    | cycles                              | 6           |
    | start_date                          | 01-May-2016 |
    | tidal_indicator                     | false       |
    And adds the following bags
    | glucose_content | name                                        | volume | days                                                     | role                        |
    | 1.36            | Baxter Dianeal PD2 1.36% (Yellow)           | 5000   | monday,tuesday,wednesday,thursday,friday,saturday,sunday | ordinary                    |
    | 1.36            | Baxter Dianeal PD2 1.36% (Yellow)           | 5000   | monday,tuesday,wednesday,thursday,friday                 | ordinary                    |
    | 2.27            | Baxter Dianeal PD2 2.27% (Green)            | 5000   | saturday,sunday                                          | ordinary                    |
    | 0               | Baxter Nutrineal PD4 (Blue)                 | 2000   | monday,tuesday,wednesday,thursday,friday,saturday,sunday | ordinary                    |
    | 0               | Baxter Extraneal (Icodextrin 7.5%) (Purple) | 5000   | monday,tuesday,wednesday,thursday,friday,saturday,sunday | last_fill                   |
    | 1.36            | Baxter Dianeal PD2 1.36% (Yellow)           | 5000   | monday,tuesday,wednesday,thursday,friday,saturday,sunday | additional_manual_exchange  |
    Then the calculated regime volumes are
    | name                        | volume |
    | daily_volume                | 16000  |
    | overnight_volume            | 12000  |
    | glucose_volume_percent_1_36 | 10571  |
    | glucose_volume_percent_2_27 | 1428   |
    | glucose_volume_percent_3_86 | 0      |


  # A rare variation where a last_fill has glucose content.
  Scenario: APD Wet Day Tidal with additional manual exchange 5 days a week
    When Clyde creates the following APD Regime for Patty
    | argument                            | value       |
    | fill_volume                         | 2000        |
    | last_fill_volume                    | 1500        |
    | additional_manual_exchange_volume   | 2000        |
    | cycles                              | 6           |
    | start_date                          | 01-May-2016 |
    | tidal_indicator                     | true        |
    | tidal_percentage                    | 80          |
    | tidal_full_drain_every_three_cycles | true        |
    And adds the following bags
    | glucose_content    | name                                 | volume | days                                            | role                        |
    | 1.36               | Baxter Dianeal PD2 1.36% (Yellow)           | 5000   | monday,tuesday,wednesday,thursday,friday | ordinary                    |
    | 2.27               | Baxter Dianeal PD2 2.27% (Green)            | 5000   | monday,tuesday,wednesday,thursday,friday | ordinary                    |
    | 0                  | Baxter Nutrineal PD4 (Blue)                 | 2000   | monday,tuesday,wednesday,thursday,friday | ordinary                    |
    | 2.27               | Baxter Extraneal (Icodextrin 7.5%) (Purple) | 2000   | monday,tuesday,wednesday,thursday,friday | last_fill                   |
    | 1.36               | Baxter Dianeal PD2 1.36% (Yellow)           | 5000   | monday,tuesday,wednesday,thursday,friday | additional_manual_exchange  |
    Then the calculated regime volumes are
    | name                        | volume |
    | daily_volume                | 13900  |
    | overnight_volume            | 10400  |
    | glucose_volume_percent_1_36 | 4523   |
    | glucose_volume_percent_2_27 | 4166   |
    | glucose_volume_percent_3_86 | 0      |
