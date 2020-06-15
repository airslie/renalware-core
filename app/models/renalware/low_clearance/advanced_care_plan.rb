# frozen_string_literal: true

require_dependency "renalware/events"
require_dependency "renalware/low_clearance"
require "document/base"
require "document/embedded"
require "document/enum"

module Renalware
  module LowClearance
    class AdvancedCarePlan < Events::Event
      include Document::Base

      class Document < Document::Embedded
        attribute :state, ::Document::Enum # See i18n for options
        validates :state, presence: true
      end
      has_document

      # Return e.g. "renalware/low_clearance/advanced_care_plans/toggled_cell
      def partial_for(partial_type)
        File.join("renalware/low_clearance/advanced_care_plans", partial_type)
      end
    end
  end
end
