require_dependency "renalware/hd"

module Renalware
  module HD
    class SessionFactory
      attr_reader :patient, :user

      def initialize(patient:, user:)
        @patient = patient
        @user = user
      end

      def build
        session = Session.new(
          performed_on: Time.zone.today,
          signed_on_by: user,
          start_time: Time.zone.now.change(min: (Time.zone.now.min/5)*5)
        )
        Profile.for_patient(patient).first.tap do |profile|
          session.hospital_unit = profile.hospital_unit
          session.document.info.hd_type = profile.document.dialysis.hd_type
        end

        session
      end
    end
  end
end
