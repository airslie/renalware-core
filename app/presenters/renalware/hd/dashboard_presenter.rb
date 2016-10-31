require_dependency "collection_presenter"

module Renalware
  module HD
    class DashboardPresenter
      def initialize(patient, view_context)
        @patient = patient
        @view_context = view_context
      end

      def preference_set
        @preference_set ||= PreferenceSet.for_patient(patient).first_or_initialize
      end

      def profile
        @profile ||= begin
          ProfilePresenter.new(Profile.for_patient(patient).where(active: true).first_or_initialize)
        end
      end

      def access
        @access ||= begin
          access_profile = Renalware::Accesses.cast_patient(patient).current_profile
          Accesses::ProfilePresenter.new(access_profile)
        end
      end

      def sessions
        @sessions ||= begin
          hd_sessions = Session.includes(:hospital_unit, :patient)
                               .for_patient(patient)
                               .limit(10).ordered
          CollectionPresenter.new(hd_sessions, SessionPresenter, view_context)
        end
      end

      def dry_weights
        @dry_weights ||= begin
          weights = DryWeight.for_patient(patient).limit(4).includes(:assessor).ordered
          CollectionPresenter.new(weights, DryWeightPresenter)
        end
      end

      private
      attr_accessor :patient, :view_context
    end
  end
end
