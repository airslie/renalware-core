module Renalware
  module Patients
    class SearchQuery
      attr_reader :term, :page, :per_page

      def initialize(term:, page: 1, per_page: 20)
        @term = term
        @page = page
        @per_page = per_page
      end

      def call
        search.result.page(page).per(per_page)
          .select(fields)
          .map do |patient|
            {
              id: patient.id,
              label: patient.to_s(:long)
            }
          end
      end

      private

      def search
        @search ||= Patient.ransack(family_name_cont: term).tap do |s|
          s.sorts = ["family_name", "given_name"]
        end
      end

      def fields
        %i(id family_name given_name nhs_number)
      end
    end
  end
end
