# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters::Delivery::TransferOfCare
  describe Sections::GPPracticeComponent, type: :component do
    it do
      practice = build_stubbed(:practice, name: "PracticeX")
      gp = build_stubbed(:letter_primary_care_physician, name: "GP, X")
      patient = build_stubbed(:letter_patient, practice: practice, primary_care_physician: gp)
      letter = build_stubbed(:letter, patient: patient)

      render_inline(described_class.new(letter))

      expect(page).to have_content("Dr GP, X")
      expect(page).to have_content("PracticeX")
    end
  end
end
