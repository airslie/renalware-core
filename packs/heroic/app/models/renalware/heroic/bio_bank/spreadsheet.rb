# frozen_string_literal: true

require "roo"

module Renalware
  module Heroic
    module BioBank
      class Spreadsheet
        attr_reader :spreadsheet

        def initialize(file_path)
          @spreadsheet = Roo::Spreadsheet.open(file_path, extension: :xlsx)
        end

        def samples_sheet
          @samples_sheet ||= SamplesSheet.new(spreadsheet.sheet(0))
        end

        def usage_sheet
          @usage_sheet ||= UsageSheet.new(spreadsheet.sheet(0))
        end
      end
    end
  end
end
