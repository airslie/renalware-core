require_dependency "renalware/pathology"

module Renalware
  class HashSerializer
    def self.dump(hash)
      hash.to_json
    end

    def self.load(hash)
      (hash || {}).with_indifferent_access
    end
  end

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
      belongs_to :patient, class_name: "Renalware::Pathology::Patient"
      validates :patient, presence: true
      serialize :values, HashSerializer

      def values_for_codes(codes)
        codes = Array(codes)
        values.select{ |code, _| codes.include?(code) }
      end

      def store(code:, result:, observed_at:)
        values[code.upcase.to_s] = { "result" => result, "observed_at" => observed_at }
      end

      # Note we don't defer to super here as we want methods like
      # :hgb to return nil even if they don't exist in the values hash.
      def method_missing(method, *_args, &block)
        code = method.upcase
        observation_hash = values[code]
        if observation_hash.present?
          OpenStruct.new(observation_hash.merge(code: code))
        else
          OpenStruct.new(result: nil, observed_at: nil, code: code)
        end
      end

      # Always return true so we can support unknown pathology codes - for example
      # we might be asked to provide
      #   patient.current_observation_set.hgb
      # but if its not in values we don;t want to blow up with a method missing.
      def respond_to_missing?(method_name, _include_private = false)
        return false if method_name == :to_a
        true
      end
    end
  end
end
