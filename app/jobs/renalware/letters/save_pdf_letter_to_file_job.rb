# frozen_string_literal: true

require_dependency "renalware/letters"
require "fileutils"

module Renalware
  module Letters
    class SavePdfLetterToFileJob < ApplicationJob
      queue_with_priority 1

      def perform(letter:, file_path:)
        file_path = Pathname(file_path)
        create_folder_if_not_exists(file_path)
        File.open(file_path, "wb") { |file| file << pdf_data_for(letter) }
      end

      def pdf_data_for(letter)
        letter = Renalware::Letters::LetterPresenter.new(letter)
        Renalware::Letters::PdfRenderer.call(letter)
      end

      def create_folder_if_not_exists(path)
        FileUtils.mkdir_p(path.dirname)
      end
    end
  end
end
