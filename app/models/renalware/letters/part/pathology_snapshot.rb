require "renalware/letters/part"

module Renalware
  module Letters
    class Part::PathologySnapshot < Part
      def to_partial_path
        "renalware/letters/parts/pathology_snapshot"
      end
    end
  end
end
