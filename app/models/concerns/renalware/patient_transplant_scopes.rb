# frozen_string_literal: true

require_dependency "renalware"

module Renalware
  module PatientTransplantScopes
    def with_registration_statuses
      merge(Transplants::Patient.with_registration_statuses)
    end

    def self.extended(base)
      base.ransacker :transplant_registration_status do
        Arel.sql("transplant_registration_status_descriptions.name")
      end
    end
  end
end
