# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters::Delivery::TransferOfCare
  # Here we only test the top level contents of the array returned by Factory.call
  # and the relationships between them.
  describe Factories::Medications do
    describe "#call returns an array" do
      subject(:array) { described_class.call(nil) }

      context "when the patient as no medications" do
        it "has just FHIR::STU3::List with 0 entry.items"
        it "has no MedicationStatement entries"
        it "has no Medications entries"
      end

      context "when the patient 2 medications" do
        it "contains a FHIR::STU3::List with 2 entry.items"
        it "contains 2 MedicationStatement resources (ie prescription)"
        it "contains 2 Medication resources (ie drug+form)"
      end
    end
  end
end
