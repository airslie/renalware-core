require "rails_helper"

module Renalware::Medications
  RSpec.describe PrescriptionsByDrugTypeQuery, type: :model, focus: true do
    subject { described_class.new(drug_type_name: "ESA") }

    describe "#call" do
      it "returns only patients with one or more current ESA prescription" do
        # expect(subject.call.any?).to be_truthy
      end
    end
  end
end
