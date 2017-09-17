# A generic patient search that returns an AR relation that can used directly or merged into other
# queries if required in order to use the extensive patient search criteria added by the
# `identity_match` ransacker. See also a corresponding Patients::SearchForm form object and its
# partial.
#
# Example usage to find letters relating to any patient with rabbit in their surname:
#   Letter
#     .joins(:patients)
#     .merge(
#       Patients::SearchQuery.new(term: "rabbit").call
#     )
#
module Renalware
  module Patients
    class SearchQuery
      attr_reader :term

      def initialize(term:)
        @term = term
      end

      def call
        search.result
      end

      def search
        @search ||= begin
          Patient
            .search(identity_match: term).tap do |search|
              search.sorts = %w(family_name given_name)
            end
        end
      end
    end
  end
end
