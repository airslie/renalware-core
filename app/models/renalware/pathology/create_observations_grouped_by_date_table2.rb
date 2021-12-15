# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class CreateObservationsGroupedByDateTable2
      include Pagy::Backend

      attr_reader :patient, :code_group_name, :options, :per_page

      def initialize(patient:, code_group_name:, per_page: 25, **options)
        @patient = patient
        @code_group_name = code_group_name
        @options = options
        @per_page = per_page
      end

      def call
        create_observations_table
      end

      def params
        {}
      end

      private

      def create_observations_table
        ObservationsGroupedByDateTable2.new(
          relation: observations,
          observation_descriptions: code_group.observation_descriptions
        )
      end

      def observations
        pagy(
          ObservationsGroupedByDate.where(group: code_group_name, patient_id: patient.id),
          items: per_page
        )[1]
      end

      def code_group
        @code_group ||= CodeGroup.find_by!(name: code_group_name)
      end
    end
  end
end
