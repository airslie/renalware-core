require_dependency "renalware"

module Renalware
  module Clinics
    class Clinic < ActiveRecord::Base
      validates :name, presence: true

      scope :ordered, -> { order(name: :asc) }

      belongs_to :user, class_name: "Renalware::User"

      def to_s
        name
      end
    end
  end
end
