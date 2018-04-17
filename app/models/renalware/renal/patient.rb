# frozen_string_literal: true

require_dependency "renalware/renal"

module Renalware
  module Renal
    class Patient < ActiveType::Record[Renalware::Patient]
      has_one :profile
      scope :having_no_primary_renal_diagnosis, lambda {
        where(renal_profile: nil)
      }
      scope :with_profile, lambda {
        joins("LEFT OUTER JOIN renal_profiles ON renal_profiles.patient_id = patients.id")
      }
    end
  end
end
