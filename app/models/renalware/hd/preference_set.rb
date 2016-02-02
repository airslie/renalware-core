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
      validates :other_schedule, presence: true, if: :other_schedule_required?
      validates :entered_on, timeliness: { type: :date, allow_blank: true }

      private

      def other_schedule_required?
        schedule.try(:text) =~ /specify/
      end
    end
  end
end
