# frozen_string_literal: true

require "attr_extras"
require "roo"

module Renalware
  module Heroic
    module BioBank
      class GenerateUploadPreview
        pattr_initialize :upload, :user

        def call
          Renalware::FileStorage::OpenAttachedFile.call(upload.file) do |file|
            spreadsheet = Spreadsheet.new(file.path)
            upload.staged_changes = spreadsheet.samples_sheet.rows_to_be_imported.as_json
            upload.save_by!(user)
          end
        end
      end
    end
  end
end
