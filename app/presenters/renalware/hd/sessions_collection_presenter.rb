module Renalware
  module HD
    class SessionsCollectionPresenter
      def initialize(patient)
        @patient = patient
      end

      def find_all
        present(patient_sessions)
      end

      def latest
        present(patient_sessions.limit(10))
      end

      private

      def present(sessions)
        sessions.map { |session| SessionPresenter.new(session) }
      end

      def patient_sessions
        Session.for_patient(@patient).ordered
      end
    end
  end
end
