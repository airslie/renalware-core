# frozen_string_literal: true

require_dependency "renalware/research"

module Renalware
  module Research
    class StudyParticipant < ApplicationRecord
      include Accountable
      acts_as_paranoid
      validates :participant_id, presence: true, uniqueness: { scope: :study }
      validates :study, presence: true
      validates :external_id, uniqueness: true # added by a trigger
      belongs_to :study, touch: true
      belongs_to :patient,
                 class_name: "Renalware::Patient",
                 foreign_key: :participant_id,
                 touch: true

      def to_s
        patient&.to_s
      end

      def external_application_participant_url
        return if study.application_url.blank?
        study.application_url.gsub("{external_id}", external_id.to_s)
      end
    end
  end
end
