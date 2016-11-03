require "rails_helper"

module Renalware::HD
  RSpec.describe UpdateRollingPatientStatistics do
    let(:patient) { create(:hd_patient) }
    let(:user) { create(:user) }
    subject(:command) { described_class.new(patient) }

    it "creates a new rolling PatientStatistics row if one did not exist" do
      expect(PatientStatistics.count).to eq(0)

      session = build(:hd_closed_session, patient: patient, created_by: user)
      session.document = document
      session.save!

      expect(Session.count).to eq(1)

      subject.call
      expect(PatientStatistics.count).to eq(1)
      patient_statistics = PatientStatistics.first
      expect(patient_statistics.hospital_unit).to eq(session.hospital_unit)
    end

    # todo get seeds working with this
    # rubocop:disable Metrics/MethodLength
    def document
      {
        info: {
          hd_type: "hd",
          machine_no: 222,
          access_side: "right",
          access_site: "Brachio-basilic & transposition",
          access_type: "Arteriovenous graft (AVG)",
          access_type_abbreviation: "AVG",
          single_needle: "no",
          lines_reversed: "no",
          fistula_plus_line: "no",
          dialysis_fluid_used: "a10",
          is_access_first_use: "no"
        },
        dialysis: {
          flow_rate: 200,
          blood_flow: 150,
          machine_ktv: 1.0,
          machine_urr: 1,
          fluid_removed: 1.0,
          venous_pressure: 1,
          litres_processed: 1.0,
          arterial_pressure: 1
        },
        observations_after: {
          pulse: 36,
          weight: 100.0,
          bm_stix: 1.0,
          temperature: 36.0,
          blood_pressure: {
            systolic: 100,
            diastolic: 80
          }
        },
        observations_before: {
          pulse: 67,
          weight: 100.0,
          bm_stix: 1.0,
          temperature: 36.0,
          blood_pressure: {
            systolic: 100,
            diastolic: 80
          }
        }
      }
    end
    # rubocop:enable Metrics/MethodLength
  end
end
