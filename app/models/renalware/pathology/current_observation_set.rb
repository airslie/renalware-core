# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # We maintain current observations for each patient in their #current_observation_set.
    # CurrentObservationSet#values is a hash (stored as jsonb) where the OBX code
    # is the key and the result value and observation date are themselves a hash.
    # So values looks like this
    # {
    #   "HGB": {
    #     "result": 123,
    #     observed_at: "2017-12-12 12:12:12"
    #   },
    #   "CRE": {
    #     ...
    #   }
    # }
    # and *always* contains the very latest pathology result for any code.
    # We store all incoming OBX codes, not just a restricted list.
    # Legacy data might only contain a subset of codes, so #values should not be relied on
    # to cover current observations for the patients entire history, just key ones.
    # When displaying or using a patient's current_observation_set the consuming code
    # must filter out the codes it wants.
    class CurrentObservationSet < ApplicationRecord
      belongs_to :patient,
                 class_name: "Renalware::Pathology::Patient",
                 inverse_of: :current_observation_set
      validates :patient, presence: true
      serialize :values, ObservationsJsonbSerializer

      def values_for_codes(codes)
        codes = Array(codes)
        values.select{ |code, _| codes.include?(code) }
      end

      def self.null_values_hash
        HashWithIndifferentAccess.new.extend(ObservationSetMethods)
      end
    end

    class NullObservationSet
      def values
        ObservationsJsonbSerializer.load({})
      end
    end
  end
end
