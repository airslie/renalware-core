# frozen_string_literal: true

require_dependency "renalware/ukrdc"
require "attr_extras"

module Renalware
  module UKRDC
    module Incoming
      class ImportSurvey
        pattr_initialize [:patient, :survey_hash]

        def call
          responses.each do |question_code, answer|
            question = question_having_code(question_code)

            Patients::SurveyResponse.create!(
              patient_id: patient.id,
              question: question,
              value: answer,
              answered_on: answered_on
            )
          end
        end

        private

        def responses
          survey_hash[:responses]
        end

        def survey
          @survey ||= Patients::Survey.includes(:questions).find_by!(name: survey_hash[:code])
        rescue ActiveRecord::RecordNotFound
          raise UKRDC::SurveyNotFoundError, "Survey with name #{survey_hash[:code]} not found"
        end

        def question_having_code(code)
          survey.questions.detect { |q| q.code == code }.tap do |question|
            if question.nil?
              raise(
                UKRDC::QuestionNotFoundError,
                "Question with code #{code} not found in survey #{survey.name}"
              )
            end
          end
        end

        def answered_on
          survey_hash[:time]
        end
      end
    end
  end
end
