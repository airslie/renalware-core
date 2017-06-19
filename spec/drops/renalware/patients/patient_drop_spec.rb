require "rails_helper"

module Renalware::Patients
  RSpec.describe PatientDrop, type: :model do
    let(:patient) { build(:patient) }

    subject { PatientDrop.new(patient) }

    it "delegates to #hospital_identifier" do
      expect(subject.hospital_identifier).to eq(patient.hospital_identifier.to_s)
    end

    it "delegates to #current_modality" do
      allow(patient).to receive(:current_modality).and_return(build(:hd_modality_description))
      expect(subject.current_modality).to eq(patient.current_modality.to_s)
    end

    it "delegates to #name" do
      expect(subject.name).to eq(patient.to_s(:default))
    end

    it "delegates to #diabetic" do
      # document = double
      # expect(double).to receive(:diagnosis).and_return(true)
      # expect(patient).to receive(:document).and_return(OpenStruct.new(diabetes: double))
      patient.document.diabetes.diagnosis = true
      expect(subject.diabetic).to eq(patient.diabetic?)
    end
  end
end
