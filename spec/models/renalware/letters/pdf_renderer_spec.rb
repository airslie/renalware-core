# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    describe PdfRenderer, type: :model do
      it "renders a PDF" do
        primary_care_physician = build_stubbed(:letter_primary_care_physician)
        patient = build_stubbed(:letter_patient, primary_care_physician: primary_care_physician)
        letter = build(:approved_letter, patient: patient)
        letter.build_main_recipient(person_role: :primary_care_physician)
        letter.complete(by: build_stubbed(:user))

        pdf_content = PdfRenderer.call(letter)

        expect(pdf_content).to start_with("%PDF")
      end
    end
  end
end
