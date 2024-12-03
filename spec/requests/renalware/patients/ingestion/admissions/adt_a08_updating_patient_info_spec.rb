# frozen_string_literal: true

describe "HL7 ADT^A08 message handling: 'Patient Update Info (for current episode)'" do
  # This trigger event is used when any patient information has changed but when no other trigger
  # event has occurred. For example, an A08 event can be used to notify the receiving systems of a
  # change of address or a name change. The A08 event can include information specific to an episode
  # of care, but it can also be used for demographic information only.

  # rubocop:disable Layout/LineLength
  # Example message
  #   MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241104150356||ADT^A08|Q1663235330T1667361997X221285A1117|P|2.4
  #   EVN|A08|20241104150350
  #   PID|1||10769847^^^RNJ 5C4 MRN^MRN||ZZZTEST^TWIN 1MOM^^^^^CURRENT||20241104143500|2|||The Royal London Hospital^PO Box 59^^LONDON^E1 1BB^^HOME^^||""^MOBILE~""^HOME~""^EMAIL|""^BUSINESS||S||913401059||||L||||||||N
  #   PD1|||ST. STEPHENS HEALTH CENTRE^^F84034|G8901343^BOOMLA^S^^^^^^EXTID
  #   PV1|1|I|RNJ RLH 6Z^a Side 28^28ca^RNJ ROYALLONDON^^BED^RNJ MainBld RLH|22||RNJ RLH 6F^a Side 28^28ca^RNJ ROYALLONDON^^BED^RNJ MainBld RLH|Z2736330|||424||||79||||NEWBORN|924301136^^""^^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON|||||20241104143500|
  # rubocop:enable Layout/LineLength
  it "wip"
end
