module Renalware
  module Patients
    class PracticeSearchQuery
      attr_reader :search_term

      def initialize(search_term:)
        @search_term = search_term
      end

      def call
        return [] if search_term.blank?

        term = "%#{search_term}%"
        Practice.select(:id, :name)
                .joins(:address)
                .where("patient_practices.name ILIKE ? OR addresses.postcode ILIKE ?", term, term)
        # .select("patient_practices.id", "patient_practices.name")
      end
    end
  end
end
