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

    # We mix this module into any database-returned jsonb hash of observations
    # (e.g. CurrentObservationSet.values and Letter.pathology_snapshot)
    module ObservationSetMethods
      # Support these syntaxes
      #   values.hgb # => { result: ... observed_at: ...}
      #   values.HGB # => { result: ... observed_at: ...}
      #   values.hgb_result # => 3.3
      #   values.hgb_observed_at # => "2017-17-01"
      # So the values has methods corresponding to the entire set of possible
      # OBX codes, and also methods to reach in and get their result and observed_at date
      def method_missing(method_name, *_args, &_block)
        code, suffix = method_parts(method_name)
        return super unless AllObservationCodes.include?(code)
        observation_hash_or_hash_element_for(code, suffix)
      end

      # From eg hgb_result, returns
      # [:HGB, "result"]
      def method_parts(method_name)
        matches = method_name.to_s.match(/([^_]*)(\w*)/)
        [matches[1]&.upcase&.to_sym, matches[2]]
      end

      def observation_hash_or_hash_element_for(code, suffix)
        obs_hash = self[code]
        return nil if obs_hash.nil? # the patient may not have this observation in the set
        return obs_hash[:result] if suffix == "_result"
        return Date.parse(obs_hash[:observed_at]) if suffix == "_observed_at"
        obs_hash
      end
    end

    class ObservationsJsonbSerializer
      def self.dump(hash)
        JSON.parse hash.to_json
      end

      def self.load(hash)
        new_hash = if hash.nil? then {}
                   elsif hash.is_a?(Hash) then hash
                   else JSON.parse(hash)
                   end
        new_hash
          .with_indifferent_access
          .extend(ObservationSetMethods)
      end
    end
  end
end
