# frozen_string_literal: true

describe "HL7 ADT^A03 message handling: 'Patient Discharge'" do
  # An A03 event signals the end of a patient's stay in a healthcare facility.
  # It signals that the patient's status has changed to "discharged" and that a discharge date
  # has been recorded. The patient is no longer in the facility. The patient's location prior
  # to discharge should be entered in PV1-3 - Assigned Patient Location.

  # rubocop:disable Layout/LineLength
  # Example message
  #   MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241105102930||ADT^A03|Q1663235408T1667362075X221298A1117|P|2.4
  #   EVN|A03|20241105102900
  #   PID|1||10769845^^^RNJ 5C4 MRN^MRN||ZZZTEST^MOM^^^^^CURRENT||19910101|2|||The Royal London Hospital^PO Box 59^^LONDON^E1 1BB^^HOME^^||0777747444^MOBILE~""^HOME~""^EMAIL|""^BUSINESS||""||913401058||||L||||||||N
  #   PD1|||ST. STEPHENS HEALTH CENTRE^^F84034|G8901343^BOOMLA^S^^^^^^EXTID
  #   PV1|1|I|RNJ RLH 8Z^c Side 6^26^RNJ ROYALLONDON^^BED^RNJ MainBld RLH|22||RNJ RLH 8Z^c Side 6^26^RNJ ROYALLONDON^^BED^RNJ MainBld RLH|C43011451|G8902343||501||||19||||MATERNITY|924301135^^""^^VISITID|||||||||||||||||93768737|19||RNJ ROYALLONDON|||||20241104134800|20241105102900
  # rubocop:enable Layout/LineLength
  it "wip"
end
