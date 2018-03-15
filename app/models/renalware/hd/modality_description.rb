# frozen_string_literal: true

require_dependency "renalware/hd"

module Renalware
  module HD
    class ModalityDescription < Modalities::Description
      def to_sym
        :hd
      end
    end
  end
end
