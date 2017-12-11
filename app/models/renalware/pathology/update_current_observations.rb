require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class UpdateCurrentObservations
      # 1 get patient
      # 2 get or create current set
      # 3 update and save
      def call(params)
        patient = find_patient(params[:patient_id])
        set = patient.fetch_current_observation_set

        params[:observation_request][:observations_attributes].each do |new_obs|
          description = ObservationDescription.find(new_obs[:description_id])
          set.values[description.code] = new_obs.slice(:result, :observed_at)
        end

        set.save!
      end

      private

      def find_patient(id)
        Pathology::Patient.find_by(id: id)
      end
    end
  end
end
