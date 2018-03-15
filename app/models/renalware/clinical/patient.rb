# frozen_string_literal: true

require_dependency "renalware/clinical"

module Renalware
  module Clinical
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :allergies

      # These statuses match NHS standards for the display of recorded allergy status.
      # Note that
      # - if no_known_allergies then patient.allergies must be empty
      # - if known_allergies then patient.allergies must be not be empty
      # - unavailable is not currently used
      enumerize :allergy_status,
                in: %i(unrecorded
                       known_allergies
                       no_known_allergies
                       unavailable),
                default: "unrecorded"
    end
  end
end
