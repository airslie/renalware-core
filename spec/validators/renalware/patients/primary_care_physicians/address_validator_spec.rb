require "rails_helper"

module Renalware::Patients::PrimaryCarePhysicians
  describe AddressValidator do
    describe "validate" do
      it "validates an address is present on the Primary Care Physician" do
        doc = build_stubbed(:primary_care_physician)
        AddressValidator.new.validate(doc)
        expect(doc.errors[:address]).to match_array(["or practice must be present"])
      end

      it "does nothing when the Primary Care Physician has an address" do
        doc = build_stubbed(
          :primary_care_physician,
          address: build_stubbed(:address),
          practices: [build_stubbed(:practice)]
        )
        AddressValidator.new.validate(doc)
        expect(doc.errors[:address]).to be_empty
      end
    end
  end
end
