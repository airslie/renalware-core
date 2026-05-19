# frozen_string_literal: true

require "renalware"

module Renalware
  module Heroic
    module Reports
      def self.table_name_prefix
        "renalware_heroic.report_"
      end
    end
  end
end
