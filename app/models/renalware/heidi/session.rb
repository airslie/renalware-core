module Renalware
  module Heidi
    class Session < ApplicationRecord
      include RansackAll

      self.table_name = "heidi_sessions"

      belongs_to :patient, class_name: "Renalware::Patient"
      belongs_to :user, class_name: "Renalware::User"
      belongs_to :clinic_visit, class_name: "Renalware::Clinics::ClinicVisit", optional: true

      enum :status, {
        launched: "launched",
        synced: "synced",
        sync_failed: "sync_failed"
      }

      validates :heidi_session_id, presence: true, uniqueness: true
      validates :heidi_patient_profile_id, presence: true
    end
  end
end
