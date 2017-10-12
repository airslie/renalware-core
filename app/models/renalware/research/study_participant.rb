require_dependency "renalware/research"

module Renalware
  module Research
    class StudyParticipant < ApplicationRecord
      include Accountable
      acts_as_paranoid
      validates :participant_id, presence: true, uniqueness: { scope: :study }
      validates :study, presence: true
      belongs_to :study
      belongs_to :patient, class_name: "Renalware::Patient", foreign_key: :participant_id

      def to_s
        patient&.to_s
      end
    end
  end
end
#       include Accountable
#       acts_as_paranoid

#       validates :code, presence: true
#       validates :description, presence: true
#       validates :started_on, timeliness: { type: :date, allow_blank: true }
#       validates :terminated_on, timeliness: { type: :date, allow_blank: true, after: :started_on }

#       scope :ordered, -> { order(created_at: :asc) }
#     end
#   end
# end
