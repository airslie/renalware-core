# frozen_string_literal: true

module Renalware
  module HD
    class MDMPatientsForm
      include ActiveModel::Model
      include Virtus::Model

      attribute :hospital_unit_id, Integer
      attribute :schedule_definition_ids, String

      def ransacked_parameters
        {
          hd_profile_hospital_unit_id_eq: hospital_unit_id,
          hd_profile_schedule_definition_id_in: schedule_definition_ids_array
        }
      end

      private

      # We use eg "[1,2,3]" to [1,2,3]
      def schedule_definition_ids_array
        return if schedule_definition_ids.blank?
        schedule_definition_ids.scan(/\d+/).map(&:to_i)
      end
    end
  end
end
