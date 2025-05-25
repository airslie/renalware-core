# rubocop:disable Layout/LineLength, Naming/FileName

describe "HL7 ORM^O01 message handling: 'Refer to Renal'" do
  # The ORM^O01 event can be triggered from eg Millennium as a request order to refer the patient
  # to Renal. Used e.g at Barts. There could be OP or IP variants.
  # We create the patient if they are not already in Renalware,
  # and concat the OBX segments into a single note on the patient record.
  #
  # Example message:
  #
  # MSH|^~\&|BLT_TIE|BLT|RENALWARE|RENALWARE|20250307142935||ORM^O01|Q1779262221T1783390016A1044|P|2.4
  # PID|1||11260332^^^RNJ 5C4 MRN^MRN||TEST^TEST^^^^^CURRENT||19880930|2|||2 X Road^^^LONDON^POSTCODE^^HOME^^||""^MOBILE~0123456789^HOME~""^EMAIL|""^BUSINESS||""||19072132||||K||||||||N
  # PD1|||THE X HTH CTR^^F84062|G11111^SMITH^AM^^^^^^EXTID
  # PV1|1|O|R1H Clinic^^^R1H WHIPPSCROSS^^AMB^R1H XXXX|""|||C123123123^Jones^Ccc^Ddd^^^^^NHSCONSULTANTNUMBER^PRSNL^^^NONGP^""|G9401882^SMITH^AM^^^^^^^EXTID^PRSNL^^^EXTID^""||502||||""||||OUTPATIENT|123^^^RNJATTNUM^VISITID|||||||||||||||||""|""||R1H WHIPPSCROSS|||||20241218104725|
  # ORC|F|5541473217^XX_ORDERID|||CM||||20250307142934|^Jones^Ccc^^^^^^^PRSNL|||||20250307142934||||^Jones^Ccc^^^^^^^PRSNL
  # OBR|1|5541473217^XX_ORDERID||Refer to Renal (OP)^Refer to Renal (OP)||||||||||||||||||20250307142934||C|||1^^0^20250307142500^^""
  # OBX|1|TS|Requested Start Date/Time^Requested Start Date/Time||20250307142500
  # OBX|2|ST|Renal Patient to be seen at^Renal Patient to be seen at||ABC
  # OBX|3|ST|Renal Referral to sub-specialty^Renal Referral to sub-specialty||Acute transplant (<3 months)
  # OBX|4|ST|Renal Priority^Renal Priority||Routine
  # OBX|5|ST|Renal Reason for referral^Renal Reason for referral.||test

  let(:local_patient_id) { "P123" }
  let(:family_name) { "SMITH" }
  let(:given_name) { "John" }
  let(:title) { "Mr" }
  let(:dob) { "19720822000000" }
  let(:sex) { "M" }
  let(:nhs_number) { "6973185665" }
  let(:gp_code) { "G1234567" }
  let(:practice_code) { "P123456" }
  let(:practice) { create(:practice, code: practice_code) }
  let(:primary_care_physician) { create(:primary_care_physician, code: gp_code) }
  let(:system_user) { create(:user, username: Renalware::SystemUser.username) }
  let(:message) do
    hl7 = <<-HL7
      MSH|^~\&|BLT_TIE|BLT|RENALWARE|RENALWARE|20250307142935||ORM^O01|Q1779262221T1783390016A1044|P|2.4
      PID|1|#{nhs_number}^^^NHS|#{local_patient_id}^^^Dover||#{family_name}^#{given_name}^^^#{title}||#{dob}|#{sex}^Female||Not Specified|34 Florence Road^SOUTH CROYDON^Surrey^^CR2 0PP^ZZ993CZ^HOME^QAD||9999999999|5554443333|NSP||NSP|||||Not Specified|.|DNU||8||NSP||Y
      PD1|||DR WHM SUMISU PRACTICE, Nowhere Surgery, 22 Raccoon Road, Erewhon, Erewhonshire^GPPRC^#{practice_code}|#{gp_code}^Deeley^DP^^^DR
      PV1|1|O|R1H Clinic^^^R1H WHIPPSCROSS^^AMB^R1H XXXX|""|||C123123123^Jones^Ccc^Ddd^^^^^NHSCONSULTANTNUMBER^PRSNL^^^NONGP^""|G9401882^SMITH^AM^^^^^^^EXTID^PRSNL^^^EXTID^""||502||||""||||OUTPATIENT|123^^^RNJATTNUM^VISITID|||||||||||||||||""|""||R1H WHIPPSCROSS|||||20241218104725|
      ORC|F|5541473217^XX_ORDERID|||CM||||20250307142934|^Jones^Ccc^^^^^^^PRSNL|||||20250307142934||||^Jones^Ccc^^^^^^^PRSNL
      OBR|1|5541473217^XX_ORDERID||Refer to Renal (OP)^Refer to Renal (OP)||||||||||||||||||20250307142934||C|||1^^0^20250307142500^^""
      OBX|1|TS|TEXT1^TEXT1||20250307142500
      OBX|2|ST|TEXT2^TEXT2||VALUE2
      OBX|3|ST|TEXT3^TEXT3||VALUE3
      OBX|4|ST|TEXT4^TEXT4||VALUE4
      OBX|5|ST|TEXT5^TEXT5||VALUE5
    HL7
    hl7.gsub(/^ */, "")
  end

  before do
    primary_care_physician
    practice
    system_user
  end

  context "when the patient exists in Renalware" do
    it "does nothing" do
      patient = build(
        :patient,
        family_name: family_name,
        given_name: "mismatched",
        nhs_number: nhs_number,
        local_patient_id: local_patient_id,
        born_on: Date.parse(dob)
      )
      patient.document.admin_notes = "pre-existing notes to preserve"
      patient.save!

      expect {
        FeedJob.new(message).perform
      }.not_to change(Renalware::Patient, :count)

      # Patient should not have been updated
      patient.reload
      expect(patient.given_name).to eq("mismatched")
      expect(patient.document.admin_notes).to eq("pre-existing notes to preserve")
    end
  end

  context "when the patient does NOT exist in Renalware" do
    it "adds them" do
      expect {
        FeedJob.new(message).perform
      }.to change(Renalware::Patient, :count).by(1)

      verify_patient_properties(Renalware::Patient.last)
    end
  end

  def verify_patient_properties(patient)
    expect(patient).to have_attributes(
      family_name: family_name,
      given_name: given_name,
      title: title,
      born_on: Date.parse(dob),
      nhs_number: nhs_number,
      primary_care_physician: primary_care_physician,
      practice: practice
    )
    expect(patient.sex.code).to eq(sex)
    expect(patient.document.admin_notes).to eq(expected_notes)
  end

  def expected_notes
    <<~NOTES.chomp
      Refer to Renal (OP)
      TEXT1: 20250307142500
      TEXT2: VALUE2
      TEXT3: VALUE3
      TEXT4: VALUE4
      TEXT5: VALUE5
    NOTES
  end
end
# rubocop:enable Layout/LineLength, Naming/FileName
