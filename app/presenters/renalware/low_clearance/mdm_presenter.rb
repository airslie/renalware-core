module Renalware
  module LowClearance
    class MDMPresenter < Renalware::MDMPresenter
      def low_clearance
        @low_clearance ||= begin
          LowClearance.cast_patient(patient).profile&.document ||
            Renalware::LowClearance::ProfileDocument.new
        end
      end
    end
  end
end
