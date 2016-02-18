require_dependency "renalware/hd"

module Renalware
  module Accesses
    class AssessmentFactory
      attr_reader :patient

      def initialize(patient:)
        @patient = patient
      end

      def build
        assessment = Assessment.new(
          performed_on: Time.zone.today
        )

        Accesses::Profile.current_for_patient(patient).tap do |profile|
          if profile
            assessment.type = profile.type
            assessment.site = profile.site
            assessment.side = profile.side
          end
        end

        assessment
      end
    end
  end
end
