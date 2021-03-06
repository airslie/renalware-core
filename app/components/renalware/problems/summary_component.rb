# frozen_string_literal: true

module Renalware
  module Problems
    # Encapsulates a 'patient problems widget' comprising some heading 'chrome' and a compact table
    # of problems (with toggleable notes). The component is designed to be displayed on a
    # clinical summary or other patient dashboard.
    class SummaryComponent < ApplicationComponent
      include ToggleHelper
      rattr_initialize [:patient!, :current_user!]

      def problems
        @problems ||= patient.problems.with_notes
      end

      def cache_key
        [patient.cache_key, patient.problems.cache_key].join("~")
      end

      def cache?
        cache_key.present?
      end

      # Always render the component chrome even if there are no problems to display
      def render?
        true
      end
    end
  end
end
