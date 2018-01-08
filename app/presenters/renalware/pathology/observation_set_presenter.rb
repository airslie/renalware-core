require_dependency "renalware/pathology"
require_dependency "attr_extras"

module Renalware
  module Pathology
    class ObservationSetPresenter < DumbDelegator
      class Observation
        attr_reader_initialize [:code, :description, :result, :observed_at]
      end

      def method_missing(method_name, **_args, &_block)
        return if __getobj__.nil?
        vals = __getobj__.values
        vals.public_send(method_name)
      end

      def respond_to_missing?(method_name, _include_private = false)
        (values.present? && values.respond_to?(method_name)) || super
      end

      def each_observation
        return unless block_given?
        __getobj__.values.sort.sort.each do |code, observation_hash|
          observation = build_observation(
            code: code,
            observation_hash: observation_hash,
            with_description: true
          )
          yield observation
        end
      end

      private

      def build_observation(code:, observation_hash:, with_description: false)
        Observation.new(
          code: code,
          result: observation_hash["result"],
          observed_at: ::Time.zone.parse(observation_hash["observed_at"]),
          description: with_description ? description_for(code) : nil
        )
      end

      def description_for(code)
        observation_description_map.fetch(code, "#{code} (no description found!)")
      end

      def observation_description_map
        @observation_description_map ||= begin
          ::Renalware::Pathology::ObservationDescription
            .pluck(:code, :name)
            .each_with_object({}) { |desc, hash| hash[desc.first] = desc.last }
        end
      end
    end
  end
end
