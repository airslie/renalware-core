# frozen_string_literal: true

require "rails_helper"
require "pdf/reader"

module Renalware
  module Letters
    describe Printing::BatchCompilePdfs do
      include LettersSpecHelper

      let(:user) { create(:user) }

      def create_batch
        batch = Letters::Batch.create!(by: create(:user))
        letter1 = create_aproved_letter_to_patient_with_cc_to_gp_and_one_contact(page_count: 1)
        letter2 = create_aproved_letter_to_patient_with_cc_to_gp_and_one_contact(page_count: 1)
        batch.items.create(letter: letter1)
        batch.items.create(letter: letter2)
        batch
      end

      # context "when the letters compile successfully" do
      #   it "compiles each letter to a PDF with address sheet + letter for each letter recipient "\
      #     "then appends into one file all pdfs together where the true letters page count = eg 2" do
      #     # pending
      #     # batch = create_batch
      #     # Dir.mktmpdir(nil, Rails.root.join("tmp").to_s) do |dir|
      #     #   puts dir
      #     #   path = Pathname(dir)

      #     #   Dir.chdir(path) do
      #     #     described_class.call(batch, user)

      #     #     expect(batch.reload.status).to eq("success")

      #     #     expect(Dir.glob("2.pdf").size).to eq(1) # compiled file
      #     #     expect(Dir.glob("3.pdf").size).to eq(0) # compiled file

      #     #     # There are 2 x 1 page letters each with 3 recipients.
      #     #     # Each stuffed letter has 4 pages - the cover sheet (2 pages), the 1 page letter and a
      #     #     # blank page added for padding to ensure the next letter starts at the correct place.
      #     #     # Hence 12 sheets per letter. 2 letters = 24 pages.
      #     #     expect(PDF::Reader.new("2.pdf").page_count).to eq(24)
      #     #   end
      #     # end
      #   end
      # end
    end
  end
end
