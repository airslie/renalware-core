require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # A singleton exposing all defined OBX codes as an array of symbols
    class AllObservationCodes
      include Singleton

      # Example usage:
      #   AllObservationCodes.include?(code)
      def self.include?(code)
        instance.all.include?(code)
      end

      def all
        @all ||= ObservationDescription.order(:code).pluck(:code).map(&:upcase).map(&:to_sym)
      end
    end

    # We mixin this into jsonb sourced hash of observations (ie CurrentObservationSet.values)
    module ObservationSetMethods
      def method_missing(method, *_args, &_block)
        code = method.upcase
        return super unless AllObservationCodes.include?(code)
        observation_hash = self[code]
        if observation_hash.present?
          OpenStruct.new(observation_hash.merge(code: code))
        else
          OpenStruct.new(result: nil, observed_at: nil, code: code)
        end
      end
      # rubocop:enable Style/MethodMissing

      # See method_missing comment
      def respond_to_missing?(method_name, _include_private = false)
        AllObservationCodes.include?(method_name.upcase)
      end
    end

    class ValuesSerializer
      def self.dump(hash)
        hash.to_json
      end

      def self.load(hash)
        if hash.nil? then {}
        elsif hash.is_a?(Hash) then hash
        else JSON.parse(hash)
        end
          .with_indifferent_access
          .extend(ObservationSetMethods)
      end
    end

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
      serialize :values, ValuesSerializer

      def values_for_codes(codes)
        codes = Array(codes)
        values.select{ |code, _| codes.include?(code) }
      end

      def store(code:, result:, observed_at:)
        values[code.upcase.to_s] = { "result" => result, "observed_at" => observed_at }
      end

      # Support these syntaxes
      #   observation_set.hgb #=> OpenStruct(code: HGB, ..)
      #   observation_set.HGB #=> OpenStruct(code: HGB, ..)
      #   observation_set.values.hgb #=> OpenStruct(code: HGB, ..)
      #   observation_set.values.HGB #=> OpenStruct(code: HGB, ..)
      # by delegating method missing to values, provided it responds to the method, which is
      # determined by a lookup on a singleton class. See ValuesSerializer.
      #
      # rubocop:disable Style/MethodMissing
      def method_missing(method, *_args, &_block)
        values.public_send(method.upcase)
      end
      # rubocop:enable Style/MethodMissing

      # See comment on method_missing
      def respond_to_missing?(method_name, _include_private = false)
        values.respond_to?(method_name.upcase)
      end
    end
  end
end
