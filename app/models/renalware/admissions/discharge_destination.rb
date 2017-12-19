require_dependency "renalware/admissions"

module Renalware
  module Admissions
    class DischargeDestination < ApplicationRecord
      acts_as_paranoid
      validates :destination, presence: true
      scope :ordered, ->{ order(destination: :asc) }
    end
  end
end
