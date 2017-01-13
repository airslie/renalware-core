require "rails_helper"

module Renalware
  describe PatientPresenter do
    subject(:presenter) { PatientPresenter.new(patient) }

    describe "#salutation" do
      context "when the patient a title" do
        it "formats as Ms Smith" do
          patient = Patient.new(title: "Ms", family_name: "Smith", given_name: "Jane")

          expect(PatientPresenter.new(patient).salutation).to eq("Ms Smith")
        end
      end
      context "when the patient has no title" do
        it "formats as in Jane Smith" do
          patient = Patient.new(title: "", family_name: "Smith", given_name: "Jane")

          expect(PatientPresenter.new(patient).salutation).to eq("Jane Smith")
        end
      end
    end
  end
end
