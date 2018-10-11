# frozen_string_literal: true

require_dependency "renalware/letters"
require "attr_extras"

module Renalware
  module Letters
    module Printing
      # Build PDF for printing. We are targetting an envelope stuffer so there will be an address
      # cover sheet in front of each letter.
      # So for a letter where the patient is the main recipient, and we CC to the GP (no practice
      # email address so snail mailing) and 1 extra CC (a contact) the output will look like
      # this:
      #
      # 1. Patient address cover sheet
      # 2. Letter
      # 3. GP address cover sheet
      # 2. Letter
      # 5. Contact address cover sheet
      # 2. Letter
      #
      # Note however the we always pad each item (address sheet, letter) with blank pages to make
      # sure duplex printing does not cause the next page recipient's content to be rendered on the
      # back of the ast page of the previous letter for example/
      #
      # Compiles print content for all input letters and outputs the merged PDF to output_file.
      # Allows batch printing if you want to print say all 2 page letters together.
      # The caller may choose for example to send the output_file could be sent back to the browser
      # for manual printing using (eg using send_file) or copy the merged PDF to a folder for
      # automated printing.
      class CreatePdfByInterleavingAddressSheetAndLetterForEachRecipient
        pattr_initialize [:letters!, :output_file!]

        def call
          # There is a choice of two methods of building the merged PDF. See pros and cons.
          # The other is UsingSeparatePdfForEachLetterSection.
          UsingOnePdfForAllLetterSections.new(
            letters: letters,
            output_file: output_file
          ).call
        end

        # For each letter, uses whkhtmltopdf to build the entire print content, ie all address
        # sheets and required instance of the letter are created as one fresh pdf (no cache will be
        # used).
        #
        # Pros:
        # - Quicker: For each letter only one PDF is generated, and although the generation is slow
        #   as it does not use the previously cached letter PDF, and it has to render all the letter
        #   sections, including the letter itself, for every recipient, its stil faster then
        #   rendering separate PDFs fo each section.
        # Cons:
        #  - wastes some resources because it does not use the cache and renders same letter
        #    multiple times in the views
        #  - cannot be 100% sure the number of pages in the final PDF will be extactly what we
        #    predict, so requires a check to load the pdf into a reader and validate the page_count
        class UsingOnePdfForAllLetterSections
          include PdfCombining
          pattr_initialize [:letters!, :output_file!]

          def call
            in_a_temporary_folder do |dir|
              Array(letters).each do |letter|
                if letter.page_count.to_i < 1
                  raise(ArgumentError, "letter.page_count not set on letter.id=#{letter.id}")
                end

                letter_filename = create_letter_pdf_in(dir, letter)
                files << letter_filename
              end
              combine_multiple_pdfs_into_one(dir, output_file)
              # For debuging:
              # FileUtils.cp output_file, "/Users/tim/Desktop/x.pdf"
              # `open /Users/tim/Desktop/x.pdf`
            end
          end

          private

          def create_letter_pdf_in(dir, letter)
            filename = "letter_#{letter.id}.pdf"
            path = dir.join(filename)
            File.open(path, "wb") { |file| file.write(DuplexInterleavedPdfRenderer.call(letter)) }
            filename
          end
        end

        # This approach generates a PDF for each address cover sheet and each
        # letter. It shells to ghostscript to merge the PDFs together in
        # the right order.
        #
        # Pros:
        # - uses the letter PDF already in the cache from when we rendered it to deduce the page
        #   count after the letter was archived
        # - uses very little memory as PDF concatenation done on disk
        # - concatentation itslef reasonable fast
        #
        # Cons:
        # - slow because it shells to wkhtmltopdf for each cover sheet, and these are unklikely to
        #   be found in tha cache. So for main recip and 2 CCs it wil call wkhtmltopdf 3 times to
        #   render the address cover sheets, and the letter PDF should be pulled from cache so that
        #   is quick at least.
        #
        class UsingSeparatePdfForEachLetterSection
          include PdfCombining
          pattr_initialize [:letters!, :output_file!]

          def call
            in_a_temporary_folder do |dir|
              Array(letters).each do |letter|
                letter_filename = create_letter_pdf_in(dir, letter)
                PrintableRecipients.for(letter).each do |recipient|
                  files << create_cover_sheet_for(recipient, letter, dir)
                  files << letter_filename
                end
              end
              combine_multiple_pdfs_into_one(dir, output_file)
            end
          end

          private

          def create_letter_pdf_in(dir, letter)
            filename = "letter_#{letter.id}.pdf"
            path = dir.join(filename)
            File.open(path, "wb") { |file| file.write(PdfRenderer.call(letter)) }
            filename
          end

          def create_cover_sheet_for(recipient, _letter, dir)
            filename = "recipient_#{recipient.id}.pdf"
            path = dir.join(filename)
            File.open(path, "wb") { |file| file.write(RecipientAddressPdfRenderer.call(recipient)) }
            filename
          end
        end
      end
    end
  end
end
