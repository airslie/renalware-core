require_dependency "renalware/research"

module Renalware
  module Research
    class StudyParticipant < ApplicationRecord
      include Accountable
      acts_as_paranoid
      validates :participant_id, presence: true, uniqueness: { scope: :study }
      validates :study, presence: true
      belongs_to :study, touch: true
      belongs_to :patient,
                 class_name: "Renalware::Patient",
                 foreign_key: :participant_id,
                 touch: true

      def to_s
        patient&.to_s
      end
    end
  end
end
