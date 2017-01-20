module Renalware
  module Patients
    class PracticeSearchQuery
      attr_reader :term

      def initialize(term:)
        @term = term
      end

      def call
        return [] unless term.present?

        term = "%#{term}%"
        Practice.select(:id, :name)
                .joins(:address)
                .where("patient_practices.name ILIKE ? OR addresses.postcode ILIKE ?", term, term)
                .select("patient_practices.id", "patient_practices.name")
      end

    end
  end
end
