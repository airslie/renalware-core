# frozen_string_literal: true

module Renalware
  module Transplants
    WAITLIST_FILTERS = %w(active suspended active_and_suspended working_up status_mismatch).freeze

    def self.table_name_prefix
      "transplant_"
    end

    def self.cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::Transplants::Patient)
    end
  end
end
