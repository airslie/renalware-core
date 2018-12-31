# frozen_string_literal: true

module Renalware
  module PD
    class MDMPatientsQuery
      include ModalityScopes
      include PatientPathologyScopes
      MODALITY_NAMES = "PD"
      DEFAULT_SEARCH_PREDICATE = "hgb_date desc"
      attr_reader :q, :relation, :named_filter

      def initialize(relation: PD::Patient.all, q:, named_filter: nil)
        @q = q || {}
        @q[:s] = DEFAULT_SEARCH_PREDICATE if @q[:s].blank?
        @relation = relation
        @named_filter = named_filter || :none
      end

      def call
        search.result
      end

      # rubocop:disable Metrics/MethodLength
      def search
        @search ||= begin
          relation
            .extending(PatientTransplantScopes)
            .extending(ModalityScopes)
            .extending(PatientPathologyScopes)
            .extending(NamedFilterScopes)
            .with_current_modality_matching(MODALITY_NAMES)
            .with_current_pathology
            .with_registration_statuses
            .left_outer_joins(:current_observation_set)
            .public_send(named_filter.to_s)
            .ransack(q)
        end
      end
      # rubocop:enable Metrics/MethodLength
    end

    module NamedFilterScopes
      def none
        self # NOOP
      end

      def patients_on_the_worry_board
        joins("RIGHT OUTER JOIN patient_worries ON patient_worries.patient_id = patients.id")
      end
      alias_method :on_worryboard, :patients_on_the_worry_board
    end
  end
end
