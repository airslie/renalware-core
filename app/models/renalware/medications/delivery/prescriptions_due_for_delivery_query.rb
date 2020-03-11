# frozen_string_literal: true

require_dependency "renalware/medications"

module Renalware
  module Medications
    module Delivery
      # Find current home delivery prescriptions with a next_delivery_date falling
      # within the specified range.
      class PrescriptionsDueForDeliveryQuery
        attr_reader :drug_type_code, :from, :to

        def initialize(drug_type_code: nil, from: nil, to: nil)
          @from = (from || 4.weeks.ago).beginning_of_day
          @to = (to || 2.weeks.since).end_of_day
          @drug_type_code = drug_type_code
        end

        def call
          query = Medications::Prescription
            .current
            .eager_load(drug: [:drug_types])
            .where(provider: :home_delivery)
            .where(next_delivery_date: (from..to))
            .order(next_delivery_date: :asc)

          if drug_type_code.present?
            query = query.where("lower(drug_types.code) = ?", drug_type_code)
          end
          query
        end
      end
    end
  end
end
