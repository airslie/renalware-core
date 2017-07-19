require "rails_helper"

module Renalware
  module Letters
    RSpec.describe PdfLetterCache do
      # let(:primary_care_physician) { build(:letter_primary_care_physician) }
      # let(:patient) { build(:letter_patient, primary_care_physician: primary_care_physician) }
      # let(:letter) do
      #   let = build(:approved_letter, id: id, patient: patient)
      #   let.build_main_recipient(person_role: :primary_care_physician)
      #   LetterPresenterFactory.new(let)
      # end

      # describe "#call" do
      #   context "when a file is found matching a letter's id and md5" do
      #     let(:id) { 1 }

      #     it "" do
      #       expected_filename ="#{id}-#{Digest::MD5.hexdigest(letter.content)}"
      #       expect(PdfLetterCache.new(letter).filename).to eq(expected_filename)
      #     end
      #   end
      # end
    end
  end
end
