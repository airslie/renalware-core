# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters::Delivery::TransferOfCare
  # Here we only test the top level contents of the array returned by Factory.call
  # and the relationships between them.
  describe Factories::Allergies do
    describe "#call" do
      subject(:array) { described_class.call(nil) }

      context "when the patient as no recorded allergies" do
        it "has a FHIR::STU3::List entry with 0 entry.items"
        it "has no AllergyIntolerance entries"
      end

      context "when the patient has been updated as having 'no known allergies'" do
        it "has a FHIR::STU3::List with 1 entry.items"
        it "has a one AllergyIntolerance with a snomed code indicating 'no known allegies'"
      end

      context "when the patient has 2 allergies" do
        it "contains a FHIR::STU3::List with 2 entry.items"
        it "contains 2 AllergyIntolerance resources"
      end
    end
  end
end
