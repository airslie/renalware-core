require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequestDescription < ActiveRecord::Base
      belongs_to :required_observation_description, class_name: "ObservationDescription"
      belongs_to :lab
      has_and_belongs_to_many :requests,
        class_name: "::Renalware::Pathology::Requests::Request"

      validates :lab, presence: true

      def to_s
        code
      end
    end
  end
end
