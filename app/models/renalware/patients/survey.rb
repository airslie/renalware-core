# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    class Survey < ApplicationRecord
      acts_as_paranoid
      has_many :questions, dependent: :destroy, class_name: "SurveyQuestion"
      validates :name, presence: true, uniqueness: true

      def to_s
        name
      end
    end
  end
end
