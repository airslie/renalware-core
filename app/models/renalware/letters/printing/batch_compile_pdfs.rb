# frozen_string_literal: true

require_dependency "renalware/letters"
require "attr_extras"

module Renalware
  module Letters
    module Printing
      # - takes a batch of letters
      # - compiles each letter along with its recipient cover sheets
      # - adds blank pages to make sure the letter always starts on an odd page
      # - appends all PDF letters
      class BatchCompilePdfs
        include PdfCombining
        PAGE_COUNTS = %w(2 3 4 5 6 7 8 9 10).freeze

        def self.call(batch, user)
          new(batch, user).call
        end

        def initialize(batch, user)
          @batch = batch
          @user = user
          @dir = Pathname(Dir.pwd)
          Rails.logger.info "Compiling letter PDFs for batch #{batch.id} in folder #{dir}"
        end

        # rubocop:disable Metrics/AbcSize
        def call
          batch.status = :processing
          batch.save_by!(user)
          batch.items.each do |item|
            validate_letter(item.letter)
            assemble_letter_pdfs(item.letter, dir)
            item.update(status: :compiled)
          end
          batch.filepath = append_files
          batch.status = :awaiting_printing
          batch.save_by!(user)
        end
        # rubocop:enable Metrics/AbcSize

        private

        attr_reader :batch, :dir, :user

        def append_files
          folder = Rails.root.join("tmp", "batched_letters")
          FileUtils.mkdir_p folder
          pdf_file = folder.join("#{batch.id}.pdf")
          glob = Dir.glob(dir.join("*.pdf"))
          combine_multiple_pdfs_into_file(filepath: pdf_file, glob: glob) if glob.any?
          Pathname(pdf_file).to_s
        end

        def page_count_allowing_for_cover_sheet(letter)
          (letter.page_count + 1).to_s
        end

        def validate_letter(letter)
          raise "Letter has no page_count" if letter.page_count.to_i.zero?
          if letter.page_count.to_i > PAGE_COUNTS.last.to_i
            raise "Letter page count (#{letter.page_count}) unexpected"
          end
        end

        # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        # TODO: refactor
        def assemble_letter_pdfs(letter, dir)
          Rails.logger.info "Interleaving address sheets and letters for letter #{letter.id}"
          letter_has_an_odd_number_of_pages = letter.page_count.odd?
          filenames = []
          working_folder = dir.join("letter_#{letter.id}")
          FileUtils.mkdir_p working_folder

          output_filepath = dir.join("compiled_letter_#{letter.id}.pdf")

          Dir.chdir(working_folder) do
            letter_filename = write_letter_to_pdf_file(letter)
            letter.recipients.each do |recipient|
              Rails.logger.info " Recipient #{recipient.id}"
              filenames << write_recipient_cover_sheet_pdf(letter, recipient)
              filenames << letter_filename
              filenames << blank_page_filename if letter_has_an_odd_number_of_pages
            end
            combine_multiple_pdfs_using_filenames(filenames, working_folder, output_filepath)
          end
        end
        # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

        # Remove letter and recipient working files
        def remove_working_files
          FileUtils.rm Dir.glob(dir.join("*.pdf"))
        end

        def write_letter_to_pdf_file(letter)
          filename = "original_letter_#{letter.id}.pdf"
          File.open(filename, "wb") do |file|
            file.write(PdfRenderer.call(letter))
          end
          filename
        end

        def write_recipient_cover_sheet_pdf(letter, recipient)
          filename = "letter_#{letter.id}_address_sheet_for_recipient_#{recipient.id}.pdf"
          RecipientAddressPagePdf.new(recipient).render_file filename
          filename
        end

        def blank_page_filename
          @blank_page_filename ||= begin
            Renalware::Engine.root.join("app", "assets", "pdf", "blank_page.pdf").to_s
          end
        end
      end
    end
  end
end
