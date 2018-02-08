require "rails_helper"

RSpec.describe "HL7 message handling end to end" do
  context "when we have an incoming HL7 msg wth > 1 OBR segment, via delayed_job" do
    let(:raw_message) do
      <<-RAW.strip_heredoc
        MSH|^~\&|HM|LBE|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||
        PID|||Z999990^^^PAS Number||RABBIT^JESSICA^^^MS||19880924|F|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR|||||||||||||||||||
        PV1||Inpatient|NIBC^^^^^^^^|||||MID^KINGS MIDWIVES||||||||||NHS|HXF888888^^^Visit Number|||||||||
        ORC|RE|^PCS|09B0099478^LA||CM||||200911111841|||MID^KINGS MIDWIVES|||||||
        OBR|1|123456^PCS|09B0099478^LA|FBC^FULL BLOOD COUNT^MB||200911111841|200911111841|||||||200911111841|B^Blood|MID^KINGS MIDWIVES||09B0099478||||200911121646||HM|F||||||||||||||||||
        OBX|1|TX|WBC^WBC^MB||6.09|10\\S\\12/L|||||F|||200911112026||BBKA^Donald DUCK|
        OBX|2|TX|RBC^RBC^MB||4.00|10\\S\\9/L|||||F|||200911112026||BBKA^Donald DUCK|
        OBR|2|111111111^PCS|100000000^LA|RLU^RENAL/LIVER/UREA^HM||201801251204|201801250541||||||.|201801250541|B^Blood|RABRO^Rabbit, Roger||100000000||||201801251249||HM|F
        OBX|1|NM|NA^Sodium^HM||136|mmol/L|||||F|||201801251249||XXXXXVC01^BHI Authchecker
        OBX|2|NM|POT^Potassium^HM||4.7|mmol/L|||||F|||201801251249||XXXXXVC01^BHI Authchecker
        OBX|3|NM|URE^Urea^HM||6.6|mmol/L|||||F|||201801251249||XXXXXVC01^BHI Authchecker
        NTE|1|L|This should be ignored
        OBX|4|NM|CRE^Creatinine^HM||102|umol/L|||||F|||201801251249||XXXXXVC01^BHI Authchecker
      RAW
    end

    it "creates the required patient observation requests and their observations" do
      patient = create(:pathology_patient, local_patient_id: "Z999990")
      create(:pathology_request_description, code: "FBC")
      %w(WBC RBC).each{ |code| create(:pathology_observation_description, code: code) }
      create(:pathology_request_description, code: "RLU")
      %w(NA POT URE CRE).each{ |code| create(:pathology_observation_description, code: code) }

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
      expect(request_fbc.observations.count).to eq(2)

      expect(request_fbc.observations.first).to have_attributes(
        result: "6.09",
        observed_at: Time.zone.parse("200911112026"),
        description: Renalware::Pathology::ObservationDescription.find_by(code: "WBC")
      )

      request_rlu = patient.observation_requests.last
      expect(request_rlu.description.code).to eq("RLU")
      expect(request_rlu.observations.count).to eq(4)

      expect(request_rlu.observations.last).to have_attributes(
        result: "102",
        observed_at: Time.zone.parse("201801251249"),
        description: Renalware::Pathology::ObservationDescription.find_by(code: "CRE")
      )
    end
  end
end
