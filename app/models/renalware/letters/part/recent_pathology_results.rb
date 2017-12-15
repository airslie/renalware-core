require "renalware/letters/part"

# When rendered, the template in `to_partial_path` will be used, and our Part object here will be
# available in the partial as `recent_pathology_results`.
module Renalware
  module Letters
    class Part::RecentPathologyResults < Part
      delegate :each, :any?, :present?, to: :recent_pathology_results

      def to_partial_path
        "renalware/letters/parts/recent_pathology_results"
      end

      private

      def recent_pathology_results
        @recent_pathology_results ||= begin
          letter.pathology_snapshot
        end
      end
    end
  end
end
