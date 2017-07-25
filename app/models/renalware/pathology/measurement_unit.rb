require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class MeasurementUnit < ApplicationRecord
      validates :name, presence: true
      has_many :observation_descriptions
    end
  end
end
