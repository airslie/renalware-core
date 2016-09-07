require "rails_helper"

module Renalware::Patients::PrimaryCarePhysicians
  describe EmailValidator do
    describe "validate" do
      it "validates an email is present on the Primary Care Physician" do
        doc = build_stubbed(:primary_care_physician, email: nil)
        EmailValidator.new.validate(doc)
        expect(doc.errors[:email]).to match_array(["or an email address for a practice must be present"])
      end

      it "does nothing when the Primary Care Physician has an email" do
        doc = build_stubbed(:primary_care_physician, practices: [build_stubbed(:practice)])
        EmailValidator.new.validate(doc)
        expect(doc.errors[:email]).to be_empty
      end
    end
  end
end
