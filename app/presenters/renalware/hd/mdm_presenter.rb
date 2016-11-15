module Renalware
  module HD
    class MDMPresenter
      attr_reader :patient, :view_context

      def initialize(patient:, view_context:)
        @patient = patient
        @view_context = view_context
      end

      def sessions
        @sessions ||= begin
          sessions = Sessions::LatestPatientSessionsQuery
                       .new(patient: patient)
                       .call(max_sessions: 6)
          CollectionPresenter.new(sessions, SessionPresenter, view_context)
        end
      end

      def hd_profile
        @hd_profile ||= begin
          profile = HD::Profile.for_patient(patient).first
          HD::ProfilePresenter.new(profile || NullObject.instance)
        end
      end

      def access
        @access ||= begin
          access_profile = Renalware::Accesses.cast_patient(patient).current_profile
          Accesses::ProfilePresenter.new(access_profile || NullObject.instance)
        end
      end

      def preference_set
        @preference_set ||= PreferenceSet.for_patient(patient).first || NullObject.instance
      end

      def audits
        @audits ||= PatientStatistics.for_patient(patient).limit(6).ordered
      end

      def pathology
        @pathology ||= begin
          table_view = Pathology::HistoricalObservationResults::HTMLTableView.new(view_context)
          presenter = Pathology::HistoricalObservationResults::Presenter.new
          pathology_patient = Renalware::Pathology.cast_patient(patient)
          Pathology::ViewObservationResults.new(pathology_patient.observations, presenter).call
          OpenStruct.new(table: table_view, rows: presenter.view_model)
        end
      end

      def prescriptions
        @prescriptions ||= begin
          Medications::PrescriptionsQuery.new(relation: patient.prescriptions.current)
            .call
            .with_created_by
            .with_medication_route
            .with_drugs
            .with_termination
            .map { |prescrip| Medications::PrescriptionPresenter.new(prescrip) }
        end
      end
    end
  end
end
