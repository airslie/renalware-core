require "rails_helper"

module Renalware
  module Pathology
    RSpec.describe ObservationsForDescriptionsQuery do
      describe "#call" do
        it "returns the patient's observations for the specified descriptions" do
          patient = create_patient

          descriptions = create_observations_with_descriptions(patient, "target-1", "exclude", "target-2")
          target_descriptions = filter_targeted_descriptions(descriptions)

          query = ObservationsForDescriptionsQuery.new(descriptions: target_descriptions)
          results = query.call

          expect(results.map(&observation_description_names)).to match_array(["target-1", "target-2"])
        end
      end

      def observation_description_names
        ->(observation) { observation.description.name }
      end

      def create_patient
        patient = create(:patient)
        Pathology.cast_patient(patient)
      end

      def create_observations_with_descriptions(patient, *description_names)
        description_names.map do |name|
          description = create(:pathology_observation_description, name: name)
          request = create(:pathology_observation_request, patient: patient)
          create(:pathology_observation, request: request, description: description)

          description
        end
      end

      def filter_targeted_descriptions(descriptions)
        descriptions.select { |description| description.name.start_with?("target-") }
      end
    end
  end
end
