module Renalware
  module Heidi
    class Session < ApplicationRecord
      include RansackAll

      self.table_name = "heidi_sessions"

      belongs_to :patient, class_name: "Renalware::Patient"
      belongs_to :user, class_name: "Renalware::User"
      belongs_to :clinic_visit, class_name: "Renalware::Clinics::ClinicVisit", optional: true

      enum :status, {
        preparing: "preparing",
        launched: "launched",
        synced: "synced",
        launch_failed: "launch_failed",
        sync_failed: "sync_failed"
      }

      validates :heidi_session_id, uniqueness: true, allow_nil: true
      validates :heidi_session_id, presence: true, if: :launched_or_synced?
      validates :heidi_patient_profile_id, presence: true, if: :launched_or_synced?

      private

      def launched_or_synced?
        launched? || synced?
      end
    end
  end
end
