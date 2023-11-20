# frozen_string_literal: true

module Renalware
  module Drugs
    class PatientGroupDirection < ApplicationRecord
      validates :name, presence: true

      scope :ordered, -> { order(position: :asc, name: :asc) }
      def self.policy_class = BasePolicy
    end
  end
end
