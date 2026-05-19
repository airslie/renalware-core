# frozen_string_literal: true

require "collection_presenter"

module Renalware
  module Heroic
    module BioBank
      class AliquotPresenter < SimpleDelegator
        delegate :collected_at,
                 :processed_at,
                 :storage_location,
                 :isbt,
                 to: :sample,
                 prefix: true
        delegate :patient, :sample_type, to: :sample

        def sample_type_abbreviation
          sample_type&.abbreviation
        end
      end
    end
  end
end
