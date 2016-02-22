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
        session = build_session
        apply_profile(session)
        set_default_access(session)
        session
      end

      private

      def build_session
        Session.new(
          performed_on: Time.zone.today,
          signed_on_by: user,
          start_time: current_time_rounded_to_5_minutes
        )
      end

      def apply_profile(session)
        if profile = Profile.for_patient(patient).first
          session.hospital_unit = profile.hospital_unit
          session.document.info.hd_type = profile.document.dialysis.hd_type
        end
      end

      def set_default_access(session)
        if profile = Accesses::Profile.current_for_patient(patient)
          session.document.info.access_type = profile.type.name
          session.document.info.access_site = profile.site.name
          session.document.info.access_side = profile.side
        end
      end

      def current_time_rounded_to_5_minutes
        Time.zone.now.change(min: (Time.zone.now.min / 5) * 5)
      end
    end
  end
end
