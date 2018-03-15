# frozen_string_literal: true

require_dependency "renalware/clinics"

module Renalware
  module Clinics
    class Clinic < ApplicationRecord
      validates :name, presence: true

      scope :ordered, -> { order(name: :asc) }

      belongs_to :consultant, class_name: "Renalware::User", foreign_key: :user_id

      def to_s
        name
      end
    end
  end
end
