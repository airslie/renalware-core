require_dependency "renalware/hd"

module Renalware
  module Hd
    class PreferenceSet < ActiveRecord::Base
      include PatientScope
      extend Enumerize

      belongs_to :patient
      belongs_to :hospital_unit, class_name: "Hospitals::Unit"

      enumerize :schedule,
        in: I18n.t(:schedule, scope: "enumerize.#{model_name.i18n_key}", cascade: true).keys

      has_paper_trail class_name: "Renalware::Hd::Version"

      validates :patient, presence: true
      validates :other_schedule, presence: true,
          if: ->(o) { o.schedule.try(:text) =~ /specify/ }
      validates :entered_on, timeliness: { type: :date, allow_blank: true }
    end
  end
end
