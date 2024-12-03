# frozen_string_literal: true

describe "HL7 ADT^A02 message handling: 'Patient Transfer'" do
  # An A02 event is issued as a result of the patient changing his or her assigned physical location

  # rubocop:disable Layout/LineLength
  # Example message
  #   MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241104155046||ADT^A02|Q1663235337T1667362004X221286A1117|P|2.4
  #   EVN|A02|20241104155000
  #   PID|1||10769845^^^RNJ 5C4 MRN^MRN||ZZZTEST^MOM^^^^^CURRENT||19910101|2|||The Royal London Hospital^PO Box 59^^LONDON^E1 1BB^^HOME^^||0777747444^MOBILE~""^HOME~""^EMAIL|""^BUSINESS||""||913401058||||L||||||||N
  #   PD1|||ST. STEPHENS HEALTH CENTRE^^F84034|G8901343^BOOMLA^S^^^^^^EXTID
  #   PV1|1|I|RNJ RLH 6Z^a Side 28^28^RNJ ROYALLONDON^^BED^RNJ MainBld RLH|22||RNJ RLH 6F^a Side 28^28^RNJ ROYALLONDON^^BED^RNJ MainBld RLH|Z4301145|G8901343||501||||19||||INPATIENT|924301135^^""^^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON|||||20241104134800|
  # rubocop:enable Layout/LineLength
  it "wip"
end
