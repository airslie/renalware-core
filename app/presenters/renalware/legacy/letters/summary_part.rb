# frozen_string_literal: true

module Renalware
  module Legacy
    module Letters
      class SummaryPart < Renalware::SummaryPart
        def legacy_letters
          @legacy_letters ||= Renalware::Legacy::Letter
            .for_patient(patient)
            .includes(:authored_by, :legacy_letter_author)
            .ordered
            .limit(Renalware.config.clinical_summary_max_letters_to_display)
        end

        def legacy_letter_count
          title_friendly_collection_count(
            actual: legacy_letters.size,
            total: Renalware::Legacy::Letter.for_patient(patient).count
          )
        end

        def cache_key
          [
            patient.cache_key,
            Renalware::Legacy::Letter.for_patient(patient).cache_key
          ].join("~")
        end

        def render?
          Renalware.config.legacy_letters_enabled &&
            Renalware::Legacy::Letter.for_patient(patient).exists?
        end

        def to_partial_path
          "renalware/legacy/letters/summary_part"
        end
      end
    end
  end
end
