# frozen_string_literal: true

require "rails_helper"
require "pdf/reader"

RSpec.describe "Rendering a letter for printing in an envelope stuffer", type: :request do
  include LettersSpecHelper
  let(:user) { create(:user) }

  describe "GET show" do
    it "renders a Duplex interleaved address+letter PDF" do
      letter = create_letter_to_patient_with_cc_to_gp_and_one_contact

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
    end
  end
end
