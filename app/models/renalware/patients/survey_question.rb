# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    class SurveyQuestion < ApplicationRecord
      acts_as_paranoid
      belongs_to :survey
      has_many(
        :responses,
        class_name: "SurveyResponse",
        dependent: :nullify,
        foreign_key: :question_id
      )
      validates :code, presence: true, uniqueness: { scope: :survey_id }
      validates :label, presence: true
      validates :position, presence: true
    end
  end
end
