# frozen_string_literal: true

require "collection_presenter"

module Renalware
  module Heroic
    module BioBank
      class UsagePresenter < SimpleDelegator
        delegate :sample, to: :aliquot
        delegate :collected_at,
                 :processed_at,
                 :storage_location,
                 :isbt,
                 to: :sample,
                 prefix: true
        delegate :isbt, to: :aliquot, prefix: true
        delegate :patient, :sample_type, to: :sample

        def sample_type_abbreviation
          sample_type&.abbreviation
        end

        def aliquot
          usable
        end
      end
    end
  end
end
