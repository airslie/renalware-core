# frozen_string_literal: true

require "rails_helper"
require "pdf/reader"

module Renalware
  module Letters
    describe CollatedAddressSheetAndLetterPdfRenderer, type: :model do
      include LettersSpecHelper
      subject(:renderer) { described_class }

      let(:user) { create(:user) }

      def create_letter_with_2_ccs
        practice = create(:practice, email: nil)
        primary_care_physician = create(
          :letter_primary_care_physician,
          address: build(:address, street_1: "::gp_address::")
        )

        patient = create(
          :letter_patient,
          primary_care_physician: primary_care_physician,
          practice: practice,
          by: user
        )
        patient.current_address.update(street_1: "::patient_address::")

        person = create(
          :directory_person,
          by: user,
          address: build(:address, street_1: "::contactt_address::")
        )
        create(:letter_contact, patient: patient, person: person)

        create_letter(to: :patient, patient: patient, state: :completed)
      end

      it "renders a PDF" do
        letter = create_letter_with_2_ccs

        pdf_content = renderer.call(letter)

        expect(pdf_content).to start_with("%PDF")

        reader = PDF::Reader.new(StringIO.new(pdf_content))

        # The letter itself take one page, so we should have the following pages
        # 1. Patient address
        # 2. Letter
        # 3. GP address
        # 4. Letter
        # 5. Contact address
        # 6. Letter
        expect(reader.page_count).to eq(6)
        # pages = reader.pages
        reader.pages.each do |page|
          p page.text
        end
      end
    end
  end
end
