require_dependency "renalware/deaths"

module Renalware
  module Deaths
    class ModalityDescription < ActiveType::Record[Renalware::Modalities::Description]
      def death?
        name == "Death"
      end
    end
  end
end
