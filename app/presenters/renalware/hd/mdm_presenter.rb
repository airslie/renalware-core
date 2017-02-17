module Renalware
  module HD
    class MDMPresenter < Renalware::MDMPresenter

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

      def esa_prescriptions
        @esa_prescriptions ||= begin
          Medications::PrescriptionsQuery.new(relation: patient.prescriptions)
            .call
            .having_drug_of_type("esa")
            .with_created_by
            .with_medication_route
            .with_drugs
            .with_termination
            .eager_load(drug: [:drug_types])
            .map { |prescrip| Medications::PrescriptionPresenter.new(prescrip) }
        end
      end
    end
  end
end
