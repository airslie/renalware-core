require_dependency "renalware/pathology"
require_dependency "attr_extras"

module Renalware
  module Pathology
    class ObservationSetPresenter < SimpleDelegator
      class Observation
        attr_reader_initialize [:code, :description, :result, :observed_at]
      end

      def each_observation
        return unless block_given?
        values.sort.each do |code, observation_hash|
          observation = Observation.new(
            code: code,
            description: description_for(code),
            result: observation_hash["result"],
            observed_at: Time.zone.parse(observation_hash["observed_at"])
          )
          yield observation
        end
      end

      private

      def description_for(code)
        observation_description_map.fetch(code, "#{code} (no description found!)")
      end

      def observation_description_map
        @observation_description_map ||= begin
          Renalware::Pathology::ObservationDescription
            .pluck(:code, :name)
            .each_with_object({}) { |desc, hash| hash[desc.first] = desc.last }
        end
      end
    end
  end
end
