require_dependency "renalware/pathology"

# Given a patient, an array of observation descriptions, and optionally a date
module Renalware
  module Pathology
    class BuildPathologySnapshot
      attr_reader :patient, :descriptions, :snapshot_date

      def initialize(patient:, descriptions:, snapshot_date: Time.zone.now)
        @patient = patient
        @descriptions = descriptions
        @snapshot_date = snapshot_date
      end

      def call
        build_pathology_snapshot
      end

      # Note this does not return empty descriptions (descriptions with a null observation).
      # Alternative description_name: descriptions.map(&:name)
      def build_pathology_snapshot
        observations = Pathology::CurrentObservation.where(
          patient: patient,
          description_id: Renalware::Letters::RelevantObservationDescription.all.pluck(:id)
        )
        Snapshot.new(observations)
      end

      class Snapshot
        attr_reader :observations

        def initialize(observations)
          @observations - observations
        end

        # Use to do .reject{ |obs| obs.result.blank? } but not needed now.
        def to_h
          observations.each_with_object({}) do |obs, hash|
            hash[obs.description_name] = {
              "result" => obs.result,
              "date" => I18n.l(obs.observed_at.to_date)
            }
          end
        end
      end
    end
  end
end
