require_dependency "renalware"

module Renalware
  module HD
    class MDMPresenter < Renalware::MDMPresenter
      NullObject = Naught.build do |config|
        config.black_hole
        config.define_explicit_conversions
        config.singleton
        config.predicates_return false
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
          if profile.present?
            HD::ProfilePresenter.new(profile)
          else
            NullObject.instance
          end
        end
      end

      def access
        @access ||= begin
          access_profile = Renalware::Accesses.cast_patient(patient).current_profile
          if access_profile.present?
            Accesses::ProfilePresenter.new(access_profile)
          else
            NullObject.instance
          end
        end
      end

      def preference_set
        @preference_set ||= PreferenceSet.for_patient(patient).first || NullObject.instance
      end

      def audits
        @audits ||= PatientStatistics.for_patient(patient).limit(6).ordered
      end
    end
  end
end
