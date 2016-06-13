require_dependency "renalware"

module Renalware
  module Clinics
    class Clinic < ActiveRecord::Base
      validates :name, presence: true

      scope :ordered, -> { order(name: :asc) }

      belongs_to :consultant, class_name: "Renalware::User", foreign_key: :user_id

      def to_s
        name
      end
    end
  end
end
