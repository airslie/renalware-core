module Renalware
  module Transplants
    class LiveDonorsQuery
      include ModalityScopes
      DEFAULT_ORDER = %w(family_name given_name).freeze

      def initialize(q = {})
        @q = q
      end

      def call
        search.result
      end

      def search
        @search ||= begin
          relation.search(q).tap do |search|
            search.sorts = DEFAULT_ORDER
          end
        end
      end

      private

      def relation
        Patient
          .all
          .extending(ModalityScopes)
          .with_current_modality_of_class(DonorModalityDescription)
      end

      attr_reader :q
    end
  end
end
