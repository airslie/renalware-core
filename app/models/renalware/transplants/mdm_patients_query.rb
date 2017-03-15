module Renalware
  module Transplants
    #  a list of everyone whose Modality is Transplant and the sort should
    #  be based on date of latest creatinine result descending (most recent
    #  at the top) - the default sort order should be same for all of the
    #  different filter groups
    class MDMPatientsQuery
      include ModalityScopes
      MODALITY_NAMES = ["Transplant"].freeze
      attr_reader :q, :relation, :named_filter

      def initialize(relation: Transplants::Patient.all, named_filter: nil, q: {})
        @q = q
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
            .extending(NamedFilterScopes)
            .with_current_modality_matching(MODALITY_NAMES)
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
      end
    end
  end
end
