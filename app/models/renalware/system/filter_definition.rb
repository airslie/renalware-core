module Renalware
  module System
    # Backed by JSONB, stored in view_metadata.filters, a model to allow
    # us to specify how filters for a SQL view are displayed in HTML
    class FilterDefinition
      include StoreModel::Model

      RANSACK_PREDICATES = {
        "list" => "eq",
        "multi" => "in",
        "search" => "cont"
      }.freeze

      attribute :code, :string
      # The type enum determines how the filter is constructed eg as a list of distinct values
      enum(
        :type,
        {
          list: 0,
          search: 1,
          multi: 2
        }
      )
      validates :code, presence: true
      validates :type, presence: true

      def collection?
        list? || multi?
      end

      def ransack_attribute
        "#{code}_#{ransack_predicate}"
      end

      def title
        code.humanize
        # @title ||= name.presence || code.humanize
      end

      private

      def ransack_predicate
        RANSACK_PREDICATES.fetch(type)
      end
    end
  end
end
