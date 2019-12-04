# frozen_string_literal: true

require_dependency "renalware"

module Renalware
  module Medications
    def self.table_name_prefix
      "medication_"
    end

    module Delivery
      def self.table_name_prefix
        "medication_delivery_"
      end
    end
  end
end
