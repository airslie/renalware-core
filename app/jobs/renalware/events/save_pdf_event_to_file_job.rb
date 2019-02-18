# frozen_string_literal: true

require_dependency "renalware/events"
require "fileutils"

module Renalware
  module Events
    # Used for example in a host app like renalware-kch to generate a PDF event for saving to
    # the electronic public register
    class SavePdfEventToFileJob < ApplicationJob
      queue_as :pdf_generation
      queue_with_priority 1

      def perform(event:, file_path:)
        file_path = Pathname(file_path)
        create_folder_if_not_exists(file_path)
        File.open(file_path, "wb") { |file| file << pdf_data_for(event) }
      end

      def pdf_data_for(event)
        EventPdf.new(event).build.render
      end

      def create_folder_if_not_exists(path)
        FileUtils.mkdir_p(path.dirname)
      end
    end
  end
end
