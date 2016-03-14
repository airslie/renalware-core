require "rails_helper"

module Renalware::Patients
  RSpec.describe CreatePatient do
    describe "#call" do
      it "creates the patient" do
        params = {patient: attributes_for(:patient)}

        expect{subject.call(params)}.to change{::Renalware::Patient.count}.by(1)
      end
    end
  end
end
