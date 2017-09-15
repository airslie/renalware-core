require_dependency "renalware/hd"

module Renalware
  module HD
    class PreferenceSet < ApplicationRecord
      include PatientScope
      include Accountable

      belongs_to :patient, touch: true
      belongs_to :hospital_unit, class_name: "Hospitals::Unit"
      belongs_to :schedule_definition, foreign_key: "schedule_definition_id"

      has_paper_trail class_name: "Renalware::HD::Version"

      validates :patient, presence: true
      validates :entered_on, timeliness: { type: :date, allow_blank: true }

      delegate :hospital_centre, to: :hospital_unit, allow_nil: true

      def preferred_schedule
        other_schedule || schedule_definition&.to_s
      end

      def self.policy_class
        BasePolicy
      end
    end
  end
end
