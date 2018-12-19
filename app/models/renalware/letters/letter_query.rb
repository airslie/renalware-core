# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module Letters
    module QueryableLetter
      extend ActiveSupport::Concern
      included do
        self.ransacker :effective_date, type: :date do
          Arel.sql(Letter.effective_date_sort)
        end

        def self.state_eq(state = :draft)
          where(type: Letter.state_class_name(state))
        end

        def self.finder_needs_type_condition?
          false
        end

        def self.ransackable_scopes(_auth_object = nil)
          %i(state_eq)
        end
      end
    end

    class LetterQuery
      def initialize(q: nil)
        @q = q || {}
        @q[:s] ||= ["effective_date desc"]
      end

      def call
        search.result
      end

      def search
        @search ||= Letter.include(QueryableLetter).includes(:event).ransack(@q)
      end
    end
  end
end
