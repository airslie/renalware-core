# frozen_string_literal: true

# rubocop:disable Layout/LineLength
describe "SIU^S15 - Notification of Appointment Cancellation" do
  # A notification of appointment cancellation is sent by the filler application to other
  # applications when an existing appointment has been canceled. A cancel event is used to stop a
  # valid appointment from taking place. For example, if a patient scheduled for an exam cancels
  # his/her appointment, then the appointment is canceled on the filler application.

  # Example message:

  #   MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241107153747||SIU^S15|Q166123117|P|2.4
  #   SCH|149549027|||||6080524|Nephrology Haemodialysis F/Up||60|MINUTES|^^60^20241113100000^20241113110000||||||||||||||Cancelled
  #   PID|1||10769859^^^RNJ 5C4 MRN^MRN||MOLLY^RENALTESTFIVE^^^^^CURRENT||19870101|2|||51 Sidney Street^^^LONDON^E1 2GB^^HOME^^||07898989898^MOBILE~0209999998^HOME~testemail@test.co^EMAIL|""^BUSINESS||""||13401074||||N||||||||N
  #   PD1|||THE CHRISP STREET HTH CTR^^F84062|G9401882^SMALL^AM^^^^^^EXTID
  #   PV1|1|O|RNJ Renal SBH^^^RNJ BARTS^^AMB^RNJ KGV|""|||C3590850|G9401882||361||||""||||PREADMIT|24301156^^^RNJATTNUM^VISITID|||||||||||||||||""|""||RNJ BARTS||||||
  #   RGS|1
  #   AIG|1||RNJ Chester, Dr Brook - Nurse 2
  #   AIL|1||RNJ Renal SBH^^^RNJ BARTS^^AMB^RNJ KGV

  include HL7Helpers
  include PatientsSpecHelper

  it "todo"
end
# rubocop:enable Layout/LineLength
