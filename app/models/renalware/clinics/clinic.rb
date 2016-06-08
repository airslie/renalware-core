require_dependency "renalware"

module Renalware
  module Clinics
    class Clinic < ActiveRecord::Base
      validates :name, presence: true

      scope :ordered, -> { order(name: :asc) }

      belongs_to :doctor, class_name: "Renalware::Doctor"

      def to_s
        name
      end
    end
  end
end
