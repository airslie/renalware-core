# frozen_string_literal: true

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
                       .includes(:patient, :hospital_unit, :signed_on_by, :signed_off_by)
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

      def dry_weights
        @dry_weights ||= begin
          Clinical::DryWeight.for_patient(patient).ordered.includes(:assessor).limit(5)
        end
      end

      def preference_set
        @preference_set ||= PreferenceSet.for_patient(patient).first || NullObject.instance
      end

      def audits
        @audits ||= PatientStatistics.for_patient(patient).limit(6).ordered
      end

      def rolling_audit
        @rolling_audit ||= audits.find_by(rolling: true)
      end

      def pathology_for_codes(codes = nil, per_page: 25, page: 1)
        if ENV["SINGLE_ROW_PATH"].present?
          Pathology::CreateObservationsGroupedByDateTable.new(
            patient: patient,
            observation_descriptions: pathology_descriptions_for_codes(codes),
            page: page,
            per_page: per_page
          ).call
        else
          Pathology::CreateObservationsGroupedByDateTable2.new(
            patient: patient,
            code_group_name: "default",
            page: page,
            per_page: per_page
          ).call
        end
      end
    end
  end
end
