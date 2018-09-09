# frozen_string_literal: true

require "rails_helper"
require "pdf/reader"

module Renalware
  module Letters
    module Printing
      describe EnvelopeStufferPdfRenderer, type: :model do
        DEBUG = true
        include LettersSpecHelper

        context "when patient is main recipient CCs are the GP and a letter contact" do
          context "when the letter is only 1 page long" do
            it "renders a PDF containing an address cover sheet + letter for each recipient "\
              "including blank pages where necessary" do

              letter = create_letter_to_patient_with_cc_to_gp_and_one_contact(page_count: 1)
              pdf_file = Tempfile.new("merged_pdf", Rails.root.join("tmp"))

              ms = Benchmark.ms do
                File.open(pdf_file, "wb") { |file| file.write(described_class.call(letter)) }
              end
              p "Rendering the letter/s took #{ms}"

              if DEBUG
                FileUtils.cp pdf_file.path, "/Users/tim/Desktop/x.pdf"
                `open /Users/tim/Desktop/x.pdf`
              end

              reader = PDF::Reader.new(pdf_file.path)

              # We expect the following pages
              # 1. address page for main recipient (patient)
              # 2. a blank page duplex printed on back address page
              # 3. the one page letter
              # 4. a blank page duplex printed on back of the letter
              # 5. address page for gp recipient (becuase the patient's practice was not emailed)
              # 6. a blank page duplex printed on back address page
              # 7 .the one page letter
              # 8. a blank page duplex printed on back of the letter
              # 9. address page for contact
              # 10. a blank page duplex printed on back address page
              # 11 .the one page letter
              # 12. a blank page duplex printed on back of the letter
              expect(reader.page_count).to eq(12)
              pages = reader.pages

              # Page 1 is the main recpient address sheet
              # Address cover sheets should not have a page number
              expect(pages[0].text).not_to match("Page\t1\tof\t1")
              expect(pages[0].text).to match("John Smith\nA\nB\nC\nD\nE\nF")

              # Page 2 is blank
              expect(pages[1].text).to be_blank

              # Page 3 is a copy of the letter
              expect(pages[2].text).not_to match("Page\t1\tof\t1")
              expect(pages[2].text).to match("Yours sincerely")

              # Page 4 is blank
              expect(pages[3].text).to be_blank

              # Page 5 is the GP contact
              expect(pages[4].text).to match(
                "Dr GOOD PJ\n123 Legoland\nBrewster Road\nBrownswater\nWindsor\nBerkshire\nNW1 6BB"
              )

              # Page 6 is blank
              expect(pages[5].text).to be_blank

              # Page 7 is the letter
              expect(pages[6].text).to match("Yours sincerely")

              # Page 8 is blank
              expect(pages[7].text).to be_blank

              # Page 9 is address page for the letter contact
              expect(pages[8].text).to match("Jane Contact\n1\n2\n3\n4\n5\n6")

              # Page 10 is blank
              expect(pages[9].text).to be_blank

              # Page 11 is the letter
              expect(pages[10].text).to match("Yours sincerely")

              # Page 12 is blank
              expect(pages[11].text).to be_blank
            end
          end

          context "when the letter spans 2 pages" do
            it "renders a PDF containing an address cover sheet + letter for each recipient "\
              "including blank pages where necessary" do

              # update body to tip the page across 2 pages
              letter = create_letter_to_patient_with_cc_to_gp_and_one_contact(
                body: "xxxxxxxx " * 1000,
                page_count: 2
              )
              pdf_file = Tempfile.new("merged_pdf", Rails.root.join("tmp"))

              ms = Benchmark.ms do
                File.open(pdf_file, "wb") { |file| file.write(described_class.call(letter)) }
              end
              p "Rendering the letter/s took #{ms}"

              if DEBUG
                FileUtils.cp pdf_file.path, "/Users/tim/Desktop/x.pdf"
                `open /Users/tim/Desktop/x.pdf`
              end

              reader = PDF::Reader.new(pdf_file.path)

              # We expect the following pages
              # 1. address page for main recipient (patient)
              # 2. a blank page duplex printed on back address page
              # 3. the one page letter
              # 4. a blank page duplex printed on back of the letter
              # 5. address page for gp recipient (becuase the patient's practice was not emailed)
              # 6. a blank page duplex printed on back address page
              # 7 .the one page letter
              # 8. a blank page duplex printed on back of the letter
              # 9. address page for contact
              # 10. a blank page duplex printed on back address page
              # 11 .the one page letter
              # 12. a blank page duplex printed on back of the letter
              expect(reader.page_count).to eq(12)
              pages = reader.pages

              # Page 1 is the main recpient address sheet
              # Address cover sheets should not have a page number
              expect(pages[0].text).not_to match("Page\t1\tof\t1")
              expect(pages[0].text.gsub("\n\n", "\n")).to match("John Smith\nA\nB\nC\nD\nE\nF")

              # Page 2 is blank
              expect(pages[1].text).to be_blank

              # Page 3 is a copy of the letter
              expect(pages[2].text).not_to match("Page\t1\tof\t1")
              expect(pages[2].text).to match("Yours sincerely")

              # Page 4 is blank
              expect(pages[3].text).to be_blank

              # Page 5 is the GP contact
              expect(pages[4].text.gsub("\n\n", "\n")).to match(
                "Dr GOOD PJ\n123 Legoland\nBrewster Road\nBrownswater\nWindsor\nBerkshire\nNW1 6BB"
              )

              # Page 6 is blank
              expect(pages[5].text).to be_blank

              # Page 7 is the letter
              expect(pages[6].text).to match("Yours sincerely")

              # Page 8 is blank
              expect(pages[7].text).to be_blank

              # Page 9 is address page for the letter contact
              expect(pages[8].text.gsub("\n\n", "\n")).to match("Jane Contact\n1\n2\n3\n4\n5\n6")

              # Page 10 is blank
              expect(pages[9].text).to be_blank

              # Page 11 is the letter
              expect(pages[10].text).to match("Yours sincerely")

              # Page 12 is blank
              expect(pages[11].text).to be_blank
            end
          end
        end
      end
    end
  end
end
