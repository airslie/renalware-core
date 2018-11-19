# frozen_string_literal: true

require "rails_helper"
require "pdf/reader"

module Renalware
  module Letters
    describe Printing::CreatePdfByInterleavingAddressSheetAndLetterForEachRecipient, type: :model do
      include LettersSpecHelper

      # This test is pretty slow, rendering two largish PDFs and merging them into one, but I feel
      # required as it tests the PDF merging process.
      context "when a letter to the patient has a GP and Contact CC" do
        context "when the letter is one or two pages long" do
          it "writes a merged pdf containing interleaved address and letter pages to the "\
            "specified file" do
            output_file = Tempfile.new("merged_pdf", Rails.root.join("tmp"))
            letter1 = create_aproved_letter_to_patient_with_cc_to_gp_and_one_contact
            letter2 = create_aproved_letter_to_patient_with_cc_to_gp_and_one_contact
            svc = described_class.new(
              letters: [letter1, letter2],
              output_file: output_file.path
            )
            ms = Benchmark.ms do
              svc.call
            end
            puts "Rendering the letter/s took #{ms}"

            # There are 2 (1 or 2 page) letters with 3 recipients. Each stuffed letter has 4 pages
            # Hence 12 sheets per letter. 2 letters = 24 pages.
            expect(PDF::Reader.new(output_file.path).page_count).to eq(24)
          end
        end
      end
    end
  end
end
