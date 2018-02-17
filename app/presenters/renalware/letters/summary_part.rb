require_dependency "renalware/letters"
require "collection_presenter"

module Renalware
  module Letters
    class SummaryPart < Renalware::SummaryPart
      def letters
        present_letters(find_letters)
      end

      def letters_count
        title_friendly_collection_count(
          actual: letters.size,
          total: patient.summary.letters_count
        )
      end

      def to_partial_path
        "renalware/letters/summary_part"
      end

      # We construct our cache_key from:
      # - the name of our partial
      # - patient id (important!)
      # - the current count of letters - this will decrement when a letter is deleted thus
      #   invalidating our cache (relying solely on maximum(:updated_at) would not catch this)
      # - the max updated_at so we catch any edits (or new letters, though that is also captured
      #   by including letters_count above)
      def cache_key
        [
          to_partial_path,
          patient.id,
          patient.summary.letters_count,
          date_formatted_for_cache(max_updated_at)
        ].join(":")
      end

      private

      def max_updated_at
        letters_patient.letters.maximum(:updated_at)
      end

      def find_letters
        letters_patient
          .letters
          .with_main_recipient
          .with_letterhead
          .with_author
          .with_patient
          .limit(Renalware.config.clinical_summary_max_letters_to_display)
          .order(issued_on: :desc)
      end

      def present_letters(letters)
        CollectionPresenter.new(letters, Renalware::Letters::LetterPresenterFactory)
      end

      def letters_patient
        Renalware::Letters.cast_patient(patient)
      end
    end
  end
end
