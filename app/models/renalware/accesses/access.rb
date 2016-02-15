require_dependency "renalware/accesses"

module Renalware
  module Accesses
    class Access < ActiveRecord::Base
      include PatientScope
      include Accountable
      extend Enumerize

      belongs_to :patient
      belongs_to :type, class_name: "Type"
      belongs_to :site, class_name: "Site"
      belongs_to :plan, class_name: "Plan"
      belongs_to :decided_by, class_name: "User", foreign_key: "decided_by_id"

      has_paper_trail class_name: "Renalware::Accesses::Version"

      scope :ordered, -> () { order(started_on: :desc) }

      validates :type, presence: true
      validates :site, presence: true
      validates :side, presence: true
      validates :formed_on, timeliness: { type: :date, allow_blank: true }
      validates :started_on, timeliness: { type: :date, allow_blank: true }
      validates :terminated_on, timeliness: { type: :date, allow_blank: true }
      validates :planned_on, timeliness: { type: :date, allow_blank: true }

      enumerize :side, in: %i(left right)

      def self.current_for_patient(patient)
        for_patient(patient).where(
          "started_on <= :date AND (terminated_on IS NULL OR terminated_on > :date)",
          date: Time.zone.today
        ).first
      end
    end
  end
end
