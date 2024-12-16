# frozen_string_literal: true

describe "HL7 ADT^A01 message handling: 'Inpatient admission'" do
  include HL7Helpers
  include PatientsSpecHelper

  let(:visit_number) { "124301137" }

  let(:raw_hl7) do
    hl7 = <<-HL7
      MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241104145144||ADT^A01|Q1663235323T1667361990X221284A1117|P|2.4
      EVN|A01|20241104144000
      PID|1||10769857^^^KCH^MRN||RENALOP2^MOLLY^^^^^CURRENT||19870101|2|||The Royal London Hospital^PO Box 59^^LONDON^E1 1BB^^HOME^^||""^MOBILE~""^HOME~""^EMAIL|""^BUSINESS||S||913401060||||L||||||||N
      PD1|||ST. STEPHENS HEALTH CENTRE^^F84034|G8901343^BOOMLA^S^^^^^^EXTID
      PV1|1|I|ward^room^bed^facility^loc.stat^BED^building^floor^loc.desc|||""^""^""^""^^^""|Z2736330|||424||||79||||NEWBORN|#{visit_number}^^""^^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON|||||20241104144000|
    HL7
    hl7.gsub(/^ */, "")
  end

  # An A01 event is intended to be used for "Admitted" patients only. An A01 event is sent as a
  # result of a patient undergoing the admission process which assigns the patient to a bed.
  # It signals the beginning of a patient's stay in a healthcare facility. Normally,
  # this information is entered in the primary Patient Administration system and broadcast to
  # the nursing units and ancillary systems. It includes short stay and "Adam Everyman"
  # (e.g., patient name is unknown) admissions.

  # rubocop:disable Layout/LineLength
  # Example message
  #   MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241104145144||ADT^A01|Q1663235323T1667361990X221284A1117|P|2.4
  #   EVN|A01|20241104144000
  #   PID|1||10769848^^^RNJ 5C4 MRN^MRN||ZZZTEST^TWIN 2MOM^^^^^CURRENT||20241104144000|2|||The Royal London Hospital^PO Box 59^^LONDON^E1 1BB^^HOME^^||""^MOBILE~""^HOME~""^EMAIL|""^BUSINESS||S||913401060||||L||||||||N
  #   PD1|||ST. STEPHENS HEALTH CENTRE^^F84034|G8901343^BOOMLA^S^^^^^^EXTID
  #   PV1|1|I|RNJ RLH 6Z^a Side 28^28cb^RNJ ROYALLONDON^^BED^RNJ MainBld RLH|82||""^""^""^""^^^""|Z2736330|||424||||79||||NEWBORN|124301137^^""^^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON|||||20241104144000|
  # rubocop:enable Layout/LineLength

  before do
    create(:user, :system)
    create(:modality_change_type, :default)
  end

  def create_patient
    create(
      :patient,
      local_patient_id: "10769857",
      given_name: "MOLLY",
      family_name: "RENALOP2",
      born_on: Date.parse("19870101")
    ).tap do |pat|
      pat.current_address.update!(postcode: "RG7 0JB")
    end
  end

  context "when patient is found" do
    it "creates the admission" do
      create_patient
      # ward = create(:hospital_ward, code: "ward")
      msg = hl7_message_from_raw_string(raw_hl7)

      expect {
        Renalware::Admissions::Ingestion::Commands::AdmitPatient.call(msg)
      }.to change(Renalware::Admissions::Admission, :count).by(1)

      expect(Renalware::Admissions::Admission.last).to have_attributes(
        visit_number: visit_number
      )
    end
  end
end
