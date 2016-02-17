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
          if profile
            session.hospital_unit = profile.hospital_unit
            session.document.info.hd_type = profile.document.dialysis.hd_type
          end
        end

        Accesses::Profile.current_for_patient(patient).tap do |profile|
          if profile
            session.document.info.access_type = profile.type.name
            session.document.info.access_site = profile.site.name
            session.document.info.access_side = profile.side
          end
        end

        session
      end
    end
  end
end
