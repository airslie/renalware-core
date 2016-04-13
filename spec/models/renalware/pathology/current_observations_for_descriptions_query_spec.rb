require "rails_helper"

require_dependency 'renalware/pathology'

module Renalware
  module Pathology
    RSpec.describe CurrentObservationsForDescriptionsQuery do
      describe "#call" do
        it "returns observations for the specified descriptions" do
          patient = create_patient

          descriptions = create_descriptions("target-1", "exclude", "target-2")
          create_observations(patient, descriptions)
          target_descriptions = filter_targeted_descriptions(descriptions)

          query = CurrentObservationsForDescriptionsQuery.new(descriptions: target_descriptions)
          results = query.call

          expect(results.map(&description_names)).to match_array(["target-1", "target-2"])
        end

        it "returns the null observations for descriptions not yet observed" do
          missing_descriptions = add_descriptions_not_observed_for_patient("missing-1", "missing-2")

          query = CurrentObservationsForDescriptionsQuery.new(descriptions: missing_descriptions)
          results = query.call

          expect(results.map(&description_names)).to match_array(["missing-1", "missing-2"])
        end

        it "returns the unique observation for the specified description" do
          patient = create_patient
          descriptions = create_descriptions("target-1")
          create_observations(patient, descriptions)
          create_observations(patient, descriptions)

          query = CurrentObservationsForDescriptionsQuery.new(descriptions: descriptions)
          results = query.call

          expect(results.map(&description_names)).to match_array(["target-1"])
        end
      end

      def description_names
        ->(observation) { observation.description_name }
      end

      def create_patient
        patient = create(:patient)
        Pathology.cast_patient(patient)
      end

      def create_observations(patient, descriptions)
        descriptions.map do |description|
          request = create(:pathology_observation_request, patient: patient)
          create(:pathology_observation, request: request, description: description)
        end
      end

      def create_descriptions(*names)
        names.map { |name| create_observation_description(name) }
      end

      def add_descriptions_not_observed_for_patient(*description_names)
        description_names.map { |name| create_observation_description(name) }
      end

      def create_observation_description(name)
        create(:pathology_observation_description, name: name)
      end

      def filter_targeted_descriptions(descriptions)
        descriptions.select { |description| description.name.start_with?("target-") }
      end
    end
  end
end
