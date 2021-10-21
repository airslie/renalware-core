# frozen_string_literal: true

require_dependency "renalware/clinics"

module Renalware
  module Clinics
    class Clinic < ApplicationRecord
      include Accountable
      acts_as_paranoid

      validates :name, presence: true, uniqueness: true
      validates :code, uniqueness: true

      scope :ordered, -> { order(deleted_at: :desc, name: :asc) }

      # Note sure if needed so commenting out
      # belongs_to :consultant, class_name: "Renalware::User", foreign_key: :user_id

      def to_s
        name
      end
    end
  end
end
