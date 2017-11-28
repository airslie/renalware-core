require_dependency "renalware/renal"

module Renalware
  module Renal
    module LowClearance
      class ModalityDescription < Modalities::Description
        def to_sym
          :lcc
        end
      end
    end
  end
end
