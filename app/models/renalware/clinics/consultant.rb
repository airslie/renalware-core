# frozen_string_literal: true

require_dependency "renalware/clinics"

module Renalware
  module Clinics
    class Consultant < ApplicationRecord
      include Accountable
      acts_as_paranoid

      validates :name, presence: true, uniqueness: true
      validates :code, presence: true, uniqueness: true
      scope :ordered, -> { order(deleted_at: :desc, name: :asc) }

      def to_s
        name
      end
    end
  end
end
