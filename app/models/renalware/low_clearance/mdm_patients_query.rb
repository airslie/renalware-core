# frozen_string_literal: true

require_dependency "renalware/low_clearance"

module Renalware
  module LowClearance
    class MDMPatientsQuery
      include ModalityScopes
      DEFAULT_SEARCH_PREDICATE = "hgb_date DESC"
      attr_reader :query, :relation, :named_filter

      def initialize(relation: LowClearance::Patient.all, query: nil, named_filter: nil)
        @query = query || {}
        @named_filter = named_filter || :none
        @query[:s] = DEFAULT_SEARCH_PREDICATE if @query[:s].blank?
        @relation = relation
      end

      def call
        search.result
      end

      def search
        @search ||= begin
          relation
            .extending(PatientTransplantScopes)
            .extending(PatientPathologyScopes)
            .extending(ModalityScopes)
            .extending(NamedFilterScopes)
            .with_registration_statuses
            .with_current_pathology
            .left_outer_joins(:current_observation_set)
            .with_current_modality_of_class(LowClearance::ModalityDescription)
            .public_send(named_filter.to_s)
            .search(query)
        end
      end

      module NamedFilterScopes
        def none
          self # NOOP
        end

        def supportive_care
          joins(:profile)
          .where("low_clearance_profiles.document ->> 'dialysis_plan' LIKE 'not_for_dial%'")
        end

        def on_worryboard
          joins("RIGHT OUTER JOIN patient_worries ON patient_worries.patient_id = patients.id")
        end

        def tx_candidates
          self
        end

        def urea
          where("cast(values->'URE'->>'result' as float) >= 30.0")
        end

        def hgb_low
          where("cast(values->'HGB'->>'result' as float) < 100.0")
        end

        def hgb_high
          where("cast(values->'HGB'->>'result' as float) > 130.0")
        end
      end
    end
  end
end
