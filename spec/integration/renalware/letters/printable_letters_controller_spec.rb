# frozen_string_literal: true

require "rails_helper"
require "pdf/reader"

RSpec.describe "Rendering a letter for printing in an envelope stuffer", type: :request do
  include LettersSpecHelper
  let(:user) { create(:user) }

  def create_letter_with_2_ccs
    primary_care_physician = create(
      :letter_primary_care_physician,
      address: build(:address, street_1: "::gp_address::")
    )

    patient = create(:letter_patient, primary_care_physician: primary_care_physician, by: user)
    patient.current_address.update(street_1: "::patient_address::")

    person = create(
      :directory_person,
      by: user,
      address: build(:address, street_1: "::contactt_address::")
    )
    create(:letter_contact, patient: patient, person: person)

    create_letter(to: :patient, patient: patient, state: :completed)
  end

  describe "GET show" do
    it "" do
      letter = create_letter_with_2_ccs

      get patient_letters_letter_printable_path(
        patient_id: letter.patient,
        letter_id: letter,
        format: "pdf"
      )

      expect(response).to be_success
      expect(response["Content-Type"]).to eq("application/pdf")
      filename = "JONES-Z99991-#{letter.id}-COMPLETED".upcase
      expect(response["Content-Disposition"]).to include("attachment") # but only because we asked
      expect(response["Content-Disposition"]).to include(filename)

      # open pdf and inspect
      reader = PDF::Reader.new(StringIO.new(response.body))

      # The letter itself take one page, so we should have the following pages
      # 1. Patient address
      # 2. Letter
      # 3. GP address
      # 4. Letter
      # 5. Contact address
      # 6. Letter
      expect(reader.page_count).to eq(6)

      reader.pages.each do |page|
        p page.text
      end
      pages = reader.pages
      expect(pages[0].text).to match(letter.patient.current_address.to_s)
      # test for somehting else to identify an address cover page ?
      expect(pages[1].text).to match("Yours sincerely")
      expect(pages[2].text).to match(letter.patient.primary_care_physician.address.to_s)
      expect(pages[3].text).to match("Yours sincerely")
      expect(pages[4].text).to match(letter.patient.contacts[0].address.to_s)
      expect(pages[5].text).to match("Yours sincerely")
    end
  end
end
