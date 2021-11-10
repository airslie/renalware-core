# frozen_string_literal: true

require "rails_helper"

describe "HL7 message handling end to end" do
  before do
    Renalware.config.hl7_patient_locator_strategy = :simple # as used at KCH
  end

  context "when we have an incoming HL7 msg wth > 1 OBR segment, via delayed_job" do
    let(:raw_message) do
      <<-RAW.strip_heredoc
        MSH|^~\&|HM|LBE|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||
        PID|||Z999990^^^PAS Number||RABBIT^JESSICA^^^MS||19880924|F|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR|||||||||||||||||||
        PV1||Inpatient|NIBC^^^^^^^^|||||MID^KINGS MIDWIVES||||||||||NHS|HXF888888^^^Visit Number|||||||||
        ORC|RE|^PCS|09B0099478^LA||CM||||200911111841|||MID^KINGS MIDWIVES|||||||
        OBR|1|PLACER_ORDER_NO_1^PCS|FILLER_ORDER_NO_1^LA|FBC^FULL BLOOD COUNT^MB||200911111841|200911111841|||||||200911111841|B^Blood|MID^KINGS MIDWIVES||09B0099478||||200911121646||HM|F||||||||||||||||||
        OBX|1|TX|WBC^WBC^MB||6.09|10\\S\\12/L|||||F|||200911112026||BBKA^Donald DUCK|
        OBX|2|TX|RBC^RBC^MB||4.00|10\\S\\9/L|||||F|||200911112026||BBKA^Donald DUCK|
        OBR|2|PLACER_ORDER_NO_2^PCS|FILLER_ORDER_NO_2^LA|RLU^RENAL/LIVER/UREA^HM||201801251204|201801250541||||||.|201801250541|B^Blood|RABRO^Rabbit, Roger||100000000||||201801251249||HM|F
        OBX|1|NM|NA^Sodium^HM||136|mmol/L|||||F|||201801251249||XXXXXVC01^BHI Authchecker
        OBX|2|NM|POT^Potassium^HM||4.7|mmol/L|||||F|||201801251249||XXXXXVC01^BHI Authchecker
        OBX|3|NM|URE^Urea^HM||6.6|mmol/L|||||F|||201801251249||XXXXXVC01^BHI Authchecker
        NTE|1|L|This should be ignored
        OBX|4|NM|CRE^Creatinine^HM||102|umol/L|||||F|||201801251249||XXXXXVC01^BHI Authchecker
        OBX|4|NM|EGFR^EGFR^HM||10|mmol/L|||||F|||201801251249||XXXXXVC01^BHI Authchecker
      RAW
    end

    def create_observation_descriptions_for(codes)
      Array(codes).each { |code| create(:pathology_observation_description, code: code) }
    end

    def create_request_descriptions_for(codes)
      Array(codes).each { |code| create(:pathology_request_description, code: code) }
    end

    it "creates the required patient observation requests and their observations" do
      # This tests that we create both the results (observation_request -> observations) and
      # their descriptors if missing (observation_request -> observation -> measurement_unit).
      # That is to say, the process of importing HL7 pathology results should create at the same
      # time any missing observation_request_description, observation_descripion and
      # measurement_unit rows required to satisfy the needs for storing the data.

      # Again, note we we don't need to create the OBR and OBX codes up front as these will be
      # created if not found but a default 'uknown' lab must exist in case it cannot find and lookup
      #  lab name from the HL7 msg
      create(:pathology_lab, name: "Lab: Unknown")
      patient = create(:pathology_patient, local_patient_id: "Z999990")

      # Simulate delayed_job picking up the job Mirth had inserted
      FeedJob.new(raw_message).perform

      # ...
      # Renalware::Pathology::MessageListener kicks in and creates the requests and observations
      # ...
      #
      patient.reload

      expect(patient.observation_requests.count).to eq(2)
      request_fbc = patient.observation_requests.first
      expect(request_fbc.description.code).to eq("FBC")
      expect(request_fbc.requestor_order_number).to eq("PLACER_ORDER_NO_1")
      expect(request_fbc.filler_order_number).to eq("FILLER_ORDER_NO_1")
      expect(request_fbc.observations.count).to eq(2)

      expect(request_fbc.observations.map { |obx| obx.description.code }).to eq(%w(WBC RBC))

      units = request_fbc.observations.map { |obx| obx.description.measurement_unit }

      # Assert that any units that do not exist have been created and the unit assed to the
      # description
      expect(units.compact.length).to eq(2)
      obx_descriptions = request_fbc.observations.map(&:description)
      wbc = obx_descriptions.detect { |obx| obx.code == "WBC" }
      expect(wbc.measurement_unit.name).to eq("10^12/L")
      rbc = obx_descriptions.detect { |obx| obx.code == "RBC" }
      expect(rbc.measurement_unit.name).to eq("10^9/L")

      expect(request_fbc.observations.first).to have_attributes(
        result: "6.09",
        observed_at: Time.zone.parse("200911112026"),
        description: Renalware::Pathology::ObservationDescription.find_by(code: "WBC")
      )

      request_rlu = patient.observation_requests.last
      expect(request_rlu.requestor_order_number).to eq("PLACER_ORDER_NO_2")
      expect(request_rlu.filler_order_number).to eq("FILLER_ORDER_NO_2")
      expect(request_rlu.description.code).to eq("RLU")
      expect(request_rlu.observations.count).to eq(5)

      expect(request_rlu.observations[3]).to have_attributes(
        result: "102",
        observed_at: Time.zone.parse("201801251249"),
        description: Renalware::Pathology::ObservationDescription.find_by(code: "CRE")
      )

      # EGFR should be imported as normal
      expect(request_rlu.observations.map { |obx| obx.description.code })
        .to eq(%w(NA POT URE CRE EGFR))
      expect(request_rlu.observations[4]).to have_attributes(
        result: "10",
        observed_at: Time.zone.parse("201801251249"),
        description: Renalware::Pathology::ObservationDescription.find_by(code: "EGFR")
      )
    end
  end

  context "when the HL7 message is not specific to a patient eg MFN^M02" do
    let(:raw_message) do
      <<-RAW.strip_heredoc
        MSH|^~\&|ADT|iSOFT Engine|eGate|Kings|20191030155640||MFN^M02|1861609776|P|2.3|||AL|AL
        MFI|STF|PIMS|UPD|20191030155640|20191030155640|NE
        MFE|MAD|1861609776|20191030155640|193814
        STF|193814|C1119528^^^^MAINCODE~XXX^^^^DG~C1119528^^^^GMC|Xxx^Xxxx^^^Mr|CONLT|UNKNOWN||A|100^Trauma and Orthopaedic~102^Fracture||020 0000 000^PHONE|X Hospital NHS Foundation Trust^Somewhere^London, Greater London^^N1 1AAS^UK^BUSIN|20120912000000
        PRA|200000|XYZ^XX Hospital NHS Trust^TRUST|||100^NAT^MAIN~TRAUMA^DG^MAIN~01^ABC^MAIN~FRAC^DG^SEC1~020^LOCAL^SEC1|||20120912
      RAW
    end

    it "persists the message but does not process it" do
      expect {
        FeedJob.new(raw_message).perform
      }.to change(Renalware::Feeds::Message, :count).by(1)

      msg = Renalware::Feeds::Message.last
      expect(msg.patient_identifier).to be_nil
      expect(msg.header_id).to eq("1861609776")
    end
  end

  def simple_raw_message_w_sodium(unit: "mmol/L")
    <<-RAW.strip_heredoc
    MSH|^~\&|BLB|LIVE|SCM||1111111||ORU^R01|1111111|P|2.3.1|||AL
    PID|||V1111111^^^PAS Number||SSS^SS^^^Mr||1111111|M|||s^s^^^x
    PV1||Inpatient|DMU|||||xxx^xx, xxxx||||||||||NHS|V1111111^^^Visit Number
    ORC|RE|0031111111^PCS|18T1111111^LA||CM||||201801221418|||xxx^xx, xxxx
    OBR|1|0031111111^PCS|181111111^LA|GS^UNKNOWN G\T\S^BLB||201801221418|201801221418||||||haematology + 1 extra sample|201801221418|B^Blood|xxx^xx, xxxx||18T000000001||||201801251706||BLB|F
    OBX|1|NM|NA^Sodium^HM||136|#{unit}|||||F|||201801251249||BHISVC01^BHI Authchecker
    RAW
  end

  def create_sodium_desc(mu_name:, suggested_mu_name:)
    mu = mu_name && create(:pathology_measurement_unit, name: mu_name)
    suggested_mu = suggested_mu_name && create(:pathology_measurement_unit, name: suggested_mu_name)
    create(
      :pathology_observation_description,
      code: "NA",
      measurement_unit: mu,
      suggested_measurement_unit: suggested_mu
    )
  end

  context "when an observation_description has no measurement_unit but the new HL7 message "\
          "specifies one" do
    it "creates a measurement_unit (if neccessary) and assigns it to the description" do
      create(:patient, local_patient_id: "V1111111")
      create(:pathology_request_description, code: "GS")
      sodium = create_sodium_desc(mu_name: nil, suggested_mu_name: nil)

      FeedJob.new(simple_raw_message_w_sodium).perform

      expect(sodium.reload.measurement_unit.name).to eq("mmol/L")
    end
  end

  context "when an observation_description has measurement_unit already but it is different" do
    it "leaves measurement_unit unchanged but sets suggested_measurement_unit to the new value" do
      create(:patient, local_patient_id: "V1111111")
      create(:pathology_request_description, code: "GS")
      sodium = create_sodium_desc(mu_name: "mg", suggested_mu_name: nil)

      FeedJob.new(simple_raw_message_w_sodium).perform

      sodium.reload
      expect(sodium.measurement_unit.name).to eq("mg")
      expect(sodium.suggested_measurement_unit).to be_present
      expect(sodium.suggested_measurement_unit.name).to eq("mmol/L")
    end
  end

  context "when an observation_description has measurement_unit and suggested_measurement_unit " \
          "already, and suggested_measurement_unit matches the HL7 unit" do
    it "leaves observation_description unchanged" do
      create(:patient, local_patient_id: "V1111111")
      create(:pathology_request_description, code: "GS")
      last_year = 1.year.ago

      sodium = travel_to(last_year) do
        create_sodium_desc(mu_name: "mg", suggested_mu_name: "mmol/L")
      end

      FeedJob.new(simple_raw_message_w_sodium).perform

      sodium.reload

      # The observation_description should not have been changed
      expect(sodium.updated_at).to eq(last_year.change(usec: 0))
    end
  end
end
