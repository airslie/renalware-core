# frozen_string_literal: true

require_dependency "renalware"

module Renalware
  module Renal
    AKI_ALERT_FILTERS = %w(today all).freeze

    def self.table_name_prefix
      "renal_"
    end

    def self.cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::Renal::Patient)
    end
  end
end
