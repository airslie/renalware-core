require_dependency "renalware/research"

module Renalware
  module Research
    class StudyParticipant < ApplicationRecord
      include Accountable
      acts_as_paranoid
      validates :participant_id, presence: true, uniqueness: { scope: :study }
      validates :study, presence: true
      belongs_to :study
      # rubocop:disable Rails/InverseOf
      belongs_to :patient,
                class_name: "Renalware::Patient",
                foreign_key: :participant_id
      # rubocop:enable Rails/InverseOf

      def to_s
        patient&.to_s
      end
    end
  end
end
