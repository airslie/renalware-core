# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class MeasurementUnit < ApplicationRecord
      validates :name, presence: true
      has_many :observation_descriptions, inverse_of: :measurement_unit
      belongs_to :ukrdc_measurement_unit, class_name: "Renalware::UKRDC::MeasurementUnit"

      def self.for_collection_select
        order(:name).select(:id, :name, :description).map do |row|
          desc = row.description.presence && "(#{row.description})"
          [
            [row.name, desc].compact.uniq.join(" "),
            row.id
          ]
        end
      end
    end
  end
end
