require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequestDescription < ActiveRecord::Base
      belongs_to :required_observation_description, class_name: "ObservationDescription"
      belongs_to :lab

      validates :lab, presence: true

      def to_s
        code
      end
    end
  end
end
