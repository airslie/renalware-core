# frozen_string_literal: true

require_dependency "renalware/clinical"

module Renalware
  module Clinical
    class ModalityDescription < Modalities::Description
      def to_sym
        :clinical
      end
    end
  end
end
