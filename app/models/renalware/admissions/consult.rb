require_dependency "renalware/admissions"

module Renalware
  module Admissions
    class Consult < ApplicationRecord
      include Accountable
      extend Enumerize
      acts_as_paranoid
      validates :patient_id, presence: true
      validates :started_on, presence: true
      validates :description, presence: true
      validates :consult_type, presence: true
      validates :other_site_or_ward, presence: {
        if: ->(consult){ consult.consult_site_id.blank? && consult.hospital_ward_id.blank? }
      }

      belongs_to :patient
      belongs_to :consult_site, class_name: "Admissions::ConsultSite"
      belongs_to :hospital_ward, class_name: "Hospitals::Ward"
      belongs_to :seen_by, class_name: "User"

      enumerize :transfer_priority, in: %i(unknown necessary desirable potential unnecessary)
      enumerize :aki_risk, in: %i(yes no unknown)
    end
  end
end
