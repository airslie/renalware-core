require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class MeasurementUnit < ApplicationRecord
      validates :name, presence: true
      has_many :observation_descriptions, inverse_of: :measurement_unit
    end
  end
end
