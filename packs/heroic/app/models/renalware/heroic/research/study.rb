# frozen_string_literal: true

require_relative "investigatorship"
require_relative "participation"

module Renalware
  module Heroic
    module Research
      class Study < Renalware::Research::Study
        class Document < Heroic::Document
        end
        has_document

        def self.investigatorship_class
          Investigatorship
        end

        def self.participation_class
          Participation
        end

        def self.find!
          find_by!(code: "HEROIC")
        end
      end
    end
  end
end
