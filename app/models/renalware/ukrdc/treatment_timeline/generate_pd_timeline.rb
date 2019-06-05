# frozen_string_literal: true

require_dependency "renalware/ukrdc"

module Renalware
  module UKRDC
    module TreatmentTimeline
      class GeneratePDTimeline
        pattr_initialize :modality
        delegate :patient, to: :modality

        def call; end
      end
    end
  end
end
