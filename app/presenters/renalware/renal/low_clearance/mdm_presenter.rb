module Renalware
  module Renal
    module LowClearance
      class MDMPresenter < Renalware::MDMPresenter
        def low_clearance
          @low_clearance ||= begin
            Renal.cast_patient(patient).profile&.document&.low_clearance ||
              Renalware::Renal::ProfileDocument::LowClearance.new
          end
        end
      end
    end
  end
end
