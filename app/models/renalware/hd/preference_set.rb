require_dependency "renalware/hd"

module Renalware
  module HD
    class PreferenceSet < ActiveRecord::Base
      include PatientScope
      extend Enumerize

      belongs_to :patient
      belongs_to :hospital_unit, class_name: "Hospitals::Unit"

      enumerize :schedule,
        in: I18n.t(:schedule, scope: "enumerize.#{model_name.i18n_key}", cascade: true).keys

      has_paper_trail class_name: "Renalware::HD::Version"

      validates :patient, presence: true
      validates :other_schedule, presence: true, if: :other_schedule_selected?
      validates :entered_on, timeliness: { type: :date, allow_blank: true }

      delegate :hospital_centre, to: :hospital_unit, allow_nil: true

      def preferred_schedule
        sched = other_schedule_selected? ? other_schedule : schedule.try(:text)
      end

      private

      def other_schedule_selected?
        schedule.try(:text) =~ /specify/
      end
    end
  end
end
