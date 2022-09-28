# frozen_string_literal: true

require "renalware/letters/part"

module Renalware
  module Letters
    class Part::Problems < Part
      def problems
        @problems ||= patient.problems.includes(:notes)
      end
      delegate_missing_to :problems

      # If you are wondering why #to_partial_path is not getting called when doing 'render part'
      # in a view, note this object is array-like so Rails' render only looks for #to_partial_path
      # on the array elements, not the top level arrary object. To render a single instance of
      # this part class, wrap it in an array like so:
      #   = render [part]
      def to_partial_path
        "renalware/letters/parts/problems"
      end
    end
  end
end
