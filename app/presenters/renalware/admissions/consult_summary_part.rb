# frozen_string_literal: true

require_dependency "renalware/medications"
require "collection_presenter"

module Renalware
  module Admissions
    class ConsultSummaryPart < Renalware::SummaryPart
      delegate :nhs_number, to: :patient, prefix: true

      def recent_consults
        @recent_consults ||= begin
          CollectionPresenter.new(
            Admissions::Consult.where(patient: patient).limit(5),
            Renalware::Admissions::ConsultPresenter
          )
        end
      end

      def recent_consults_count
        title_friendly_collection_count(
          actual: recent_consults.size,
          total: Admissions::Consult.where(patient: patient).count
        )
      end

      def to_partial_path
        "renalware/admissions/consults/summary_part"
      end
    end
  end
end
