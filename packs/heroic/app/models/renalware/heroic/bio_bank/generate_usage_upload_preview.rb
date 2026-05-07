# frozen_string_literal: true

require "attr_extras"
require "roo"

module Renalware
  module Heroic
    module BioBank
      class GenerateUsageUploadPreview
        pattr_initialize :upload, :user

        def call
          spreadsheet = Spreadsheet.new(file_path)
          upload.staged_changes = spreadsheet.usage_sheet.rows_to_be_imported.as_json
          upload.save_by!(user)
        end

        private

        def spreadsheet
          @spreadsheet ||= Roo::Spreadsheet.open(file_path, extension: :xlsx)
        end

        def file_path
          ActiveStorage::Blob.service.send(:path_for, @upload.file.key)
        end
      end
    end
  end
end
