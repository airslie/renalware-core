# An A02 event is issued as a result of the patient changing his or her assigned physical location
#
# rubocop:disable Layout/LineLength
# Example message
#   MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241104155046||ADT^A02|Q1663235337T1667362004X221286A1117|P|2.4
#   EVN|A02|20241104155000
#   PID|1||10769845^^^RNJ 5C4 MRN^MRN||ZZZTEST^MOM^^^^^CURRENT||19910101|2|||The Royal London Hospital^PO Box 59^^LONDON^E1 1BB^^HOME^^||0777747444^MOBILE~""^HOME~""^EMAIL|""^BUSINESS||""||913401058||||L||||||||N
#   PD1|||ST. STEPHENS HEALTH CENTRE^^F84034|G8901343^BOOMLA^S^^^^^^EXTID
#   PV1|1|I|RNJ RLH 6Z^a Side 28^28^RNJ ROYALLONDON^^BED^RNJ MainBld RLH|22||RNJ RLH 6F^a Side 28^28^RNJ ROYALLONDON^^BED^RNJ MainBld RLH|Z4301145|G8901343||501||||19||||INPATIENT|924301135^^""^^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON|||||20241104134800|
# rubocop:enable Layout/LineLength
describe "HL7 ADT^A02 message handling: 'Patient Transfer'" do
  include HL7Helpers
  include PatientsSpecHelper

  let(:visit_number) { "123" }
  let(:system_user) { create(:user, :system) }
  let(:facility) { "new facility" }
  let(:ward) { "new ward" }
  let(:room) { "new room" }
  let(:bed) { "new bed" }
  let(:building) { "new building" }
  let(:floor) { "new floor" }
  let(:consultant_family_name) { "BOOMLA" }
  let(:consultant_initial) { "S" }
  let(:consultant_code) { "G8901343" }
  let(:raw_hl7) do
    hl7 = <<-HL7
      MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241104145144||ADT^A02|Q1663235337T1667362004X221286A1117|P|2.4
      EVN|A02|20241104144000
      PID|1||10769857^^^KCH^MRN||RENALOP2^MOLLY^^^^^CURRENT||19870101|2|||The Royal London Hospital^PO Box 59^^LONDON^E1 1BB^^HOME^^||""^MOBILE~""^HOME~""^EMAIL|""^BUSINESS||S||913401060||||L||||||||N
      PD1|||ST. STEPHENS HEALTH CENTRE^^F84034|G8901343^BOOMLA^S^^^^^^EXTID
      PV1|1|I|#{ward}^#{room}^#{bed}^#{facility}^loc.stat^BED^#{building}^#{floor}^loc.desc|||""^""^""^""^^^""|#{consultant_code}^#{consultant_family_name}^#{consultant_initial}|||424||||79||||NEWBORN|#{visit_number}^^""^^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON|||||20241104144000|
    HL7
    hl7.gsub(/^ */, "")
  end

  before do
    system_user
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

  context "when the patient is not found in Renalware" do
    it "does not create the admission" do
      msg = hl7_message_from_raw_string(raw_hl7)

      expect {
        Renalware::Admissions::Ingestion::Commands::AdmitPatient.call(msg)
      }.not_to change(Renalware::Admissions::Admission, :count)
    end
  end

  context "when the patient is found in Renalware" do
    context "when they have no admission matching the visit_number" do
      it "creates the admission" do
        create_patient
        msg = hl7_message_from_raw_string(raw_hl7)

        expect {
          Renalware::Admissions::Ingestion::Commands::AdmitPatient.call(msg)
        }.to change(Renalware::Admissions::Admission, :count).by(1)

        admission = Renalware::Admissions::Admission.last
        expect(admission).to have_attributes(visit_number: visit_number)
      end
    end

    context "when they have an existing admission matching the visit_number" do
      it "updates the admission" do
        patient = create_patient
        unit = create(:hospital_unit, unit_code: "old facility", name: "old facility")
        ward = create(:hospital_ward, code: "old ward", hospital_unit: unit)
        admission = create(
          :admissions_admission,
          patient: patient,
          visit_number: visit_number,
          hospital_ward: ward,
          consultant: "Dr C",
          consultant_code: "123",
          room: "old room",
          bed: "old bed",
          building: "old building",
          floor: "old floor"
        )
        msg = hl7_message_from_raw_string(raw_hl7)

        expect {
          Renalware::Admissions::Ingestion::Commands::AdmitPatient.call(msg)
        }.not_to change(Renalware::Admissions::Admission, :count)

        admission.reload
        expect(admission).to have_attributes(
          patient_id: patient.id,
          bed: bed,
          room: room,
          building: building,
          floor: floor,
          visit_number: visit_number,
          consultant_code: consultant_code,
          consultant: [consultant_initial, consultant_family_name].join(" ")
        )
        expect(admission.hospital_ward.code).to eq("new ward")
        expect(admission.hospital_ward.hospital_unit.unit_code).to eq("new facility")
      end
    end
  end
end
