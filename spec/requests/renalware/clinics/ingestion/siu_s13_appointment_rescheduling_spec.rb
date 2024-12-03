# frozen_string_literal: true

# rubocop:disable Layout/LineLength
describe "HL7 SIU^S13 - Notification of Appointment Rescheduling" do
  # This message is sent from a filler application to notify other applications that an existing
  # appointment has been rescheduled. The information in the SCH segment and the other detail
  # segments as appropriate describe the new date(s) and time(s) to which the previously booked
  # appointment has been moved. Additionally, it describes the unchanged information in the
  # previously booked appointment.

  # Example message:
  #   MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241107154347||SIU^S13|Q1663236015T1667362682A1117|P|2.4
  #   SCH|149549023|||||Undo Cancel|Nephrology New||30|MINUTES|^^30^20241106113000^20241106120000||||||||||||||Confirmed
  #   PID|1||10769861^^^RNJ 5C4 MRN^MRN||MOLLY^RENALEIGHT^^^^^CURRENT||19870101|2|||166 Rush Home Road^^^ROMFORD^AN7 0JR^^HOME^^||0789898989^MOBILE~0209999999^HOME~testrenal@co.in^EMAIL|""^BUSINESS||M||13401076||||P||||||||N
  #   PD1|||THE CHRISP STREET HTH CTR^^F84062|G999^SMALL^AM^^^^^^EXTID
  #   PV1|1|O|RNJ Renal OPD^^^RNJ ROYALLONDON^^AMB^RNJ MainBld RLH|""|||Z3590850|G999||361||||""||||OPREFERRAL|924301153^^^RNJATTNUM^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON||||||
  #   RGS|1
  #   AIG|1||Stevens, Stanley
  #   AIL|1||RNJ Renal OPD^^^RNJ ROYALLONDON^^AMB^RNJ MainBld RLH

  include HL7Helpers
  include PatientsSpecHelper

  it "todo"
end
# rubocop:enable Layout/LineLength
