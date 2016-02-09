module Renalware
  module HD
    class LatestSessionsPresenter
      attr_reader :sessions

      def initialize(patient)
        @patient = patient
        @sessions = patient_sessions.map do |session|
          SessionPresenter.new(session)
        end
      end

      private

      def patient_sessions
        Session.for_patient(@patient).ordered.limit(10)
      end
    end
  end
end
