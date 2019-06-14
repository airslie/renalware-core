# frozen_string_literal: true

require_dependency "renalware/ukrdc"

module Renalware
  module UKRDC
    module TreatmentTimeline
      module Generators
        class DeathsTimeline
          pattr_initialize :modality

          def call; end
        end
      end
    end
  end
end