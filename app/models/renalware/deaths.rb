module Renalware
  module Deaths
    def self.cast_modality_description(description)
      ActiveType.cast(description, ::Renalware::Deaths::ModalityDescription)
    end
  end
end
