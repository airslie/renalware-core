# frozen_string_literal: true

module Renalware
  module Transplants
    #  a list of everyone whose Modality is Transplant and the sort should
    #  be based on date of latest creatinine result descending (most recent
    #  at the top) - the default sort order should be same for all of the
    #  different filter groups
    class MDMPatientsQuery
      include ModalityScopes
      include PatientPathologyScopes
      MODALITY_NAMES = ["Transplant"].freeze
      DEFAULT_SEARCH_PREDICATE = "hgb_date DESC"
      attr_reader :q, :relation, :named_filter

      def initialize(relation: Transplants::Patient.all, named_filter: nil, q: nil)
        @q = q || {}
        @q[:s] = DEFAULT_SEARCH_PREDICATE if @q[:s].blank?
        @relation = relation
        @named_filter = named_filter || :none
      end

      def call
        search.sorts = %w(given_name)
        search.result
      end

      def search
        @search ||= begin
          relation
            .extending(ModalityScopes)
            .extending(PatientPathologyScopes)
            .extending(NamedFilterScopes)
            .with_current_modality_matching(MODALITY_NAMES)
            .with_current_pathology
            .left_outer_joins(:current_observation_set)
            .public_send(named_filter.to_s)
            .search(q)
        end
      end

      module NamedFilterScopes
        def none
          self # NOOP
        end

        def patients_with_a_transplant_date_in_the_past_3_months
          joins(<<-SQL)
            LEFT JOIN transplant_recipient_operations
            ON patients.id = transplant_recipient_operations.patient_id
          SQL
          .where("transplant_recipient_operations.performed_on >= ?", 3.months.ago)
        end
        alias_method :recent, :patients_with_a_transplant_date_in_the_past_3_months

        def patients_on_the_worry_board
          joins("RIGHT OUTER JOIN patient_worries ON patient_worries.patient_id = patients.id")
        end
        alias_method :on_worryboard, :patients_on_the_worry_board

        def patients_with_a_transplant_operation_in_the_past_year
          joins(<<-SQL)
            LEFT JOIN transplant_recipient_operations
            ON patients.id = transplant_recipient_operations.patient_id
          SQL
          .where("transplant_recipient_operations.performed_on >= ?", 1.year.ago)
        end
        alias_method :past_year, :patients_with_a_transplant_operation_in_the_past_year
      end
    end
  end
end
