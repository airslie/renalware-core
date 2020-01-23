# frozen_string_literal: true

module Renalware
  module Events
    class BiopsiesComponent < ApplicationComponent
      validates :patient, presence: true

      def initialize(patient:, limit: 6)
        @patient = patient
        relation = Biopsy.for_patient(patient).includes(:created_by)
        @biopsies = relation.limit(limit).ordered
        @total_biopsies = relation.count
      end

      private

      attr_reader :patient, :biopsies, :total_biopsies
    end
  end
end
