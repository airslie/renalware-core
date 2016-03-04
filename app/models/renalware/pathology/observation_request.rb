require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationRequest < ActiveRecord::Base
      has_many :observations, foreign_key: :request_id

      accepts_nested_attributes_for :observations
    end
  end
end
