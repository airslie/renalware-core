# frozen_string_literal: true

describe "HL7 ADT^A04 message handling: 'Emergency Department Registration'" do
  # An A04 event signals that the patient has arrived or checked in as a one-time, or recurring
  # outpatient, and is not assigned to a bed. One example might be its use to signal the
  # beginning of a visit to the Emergency Room (= Casualty, etc.). Note that some systems refer
  # to these events as outpatient registrations or emergency admissions.
  # PV1-44 - Admit Date/Time is used for the visit start date/time.

  # rubocop:disable Layout/LineLength
  # Example message
  #   MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241104224101||ADT^A04|Q1663235|P|2.4
  #   EVN|A04|20241104224000
  #   PID|1||10769852^^^RNJ 5C4 MRN^MRN||TEST^PATIENT^^^^^CURRENT||19820101|2|||51 Sidney Street^^^LONDON^E1 2GE^^HOME^^||0788888888^MOBILE~0208889998^HOME~test@test.co^EMAIL|""^BUSINESS||""||13401064||||H||||||||N
  #   PD1|||THE CHRISP STREET HTH CTR^^F84062|G9401882^SMAILES^AM^^^^^^EXTID
  #   PV1|1|I|RNJ ED^""^""^RNJ ROYALLONDON^^AMB^RNJ MainBld RLH|""||""^""^""^""^^^""|Z4718615|||180||||""||||EMERGENCY|924301141^^""^^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON|||||20241104224000|
  # rubocop:enable Layout/LineLength
  it "wip"
end
