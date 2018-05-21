# frozen_string_literal: true

module Renalware
  class PathologySeeder
    def file_path_for(patient:, file_name:)
      folder = ActiveSupport::Inflector.transliterate(patient.given_name).to_s # remove cedilla
      File.join(File.dirname(__FILE__), folder.downcase, file_name)
    end

    def seed_pathology_requests_for(patient:)
      log "Adding Pathology Requests (OBR) for #{patient}" do
        file_path = file_path_for(patient: patient, file_name: "pathology_obr.csv")
        CSV.foreach(file_path, headers: true) do |row|
          request_desc = Pathology::RequestDescription.find_by!(code: row["description"])
          patient.observation_requests.find_or_create_by!(id: row["id"].to_i) do |obr|
            obr.description = request_desc
            obr.requestor_order_number = row["order_no"]
            obr.requested_at = Date.parse(row["requested_at"])
            obr.requestor_name = row["requestor_name"]
          end
        end
      end
    end

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def seed_pathology_observations_for(patient:)
      log "Adding Pathology Observations (OBX) for #{patient}" do
        file_path = file_path_for(patient: patient, file_name: "pathology_obx.csv")
        observations = []

        CSV.foreach(file_path, headers: true) do |row|
          request = Pathology::ObservationRequest.find(row["request_id"])
          observations << Pathology::Observation.new(
            request: request,
            description: Pathology::ObservationDescription.find_by!(code: row["description"]),
            result: row["result"],
            observed_at: request.requested_at + 24.hours,
            comment: row["comment"]
          )
        end
        Pathology::Observation.import! observations
      end
    end
    # rubocop:enbale Metrics/MethodLength, Metrics/AbcSize

    def seed_pathology_for(local_patient_id:)
      patient = Patient.find_by(local_patient_id: local_patient_id)
      pathology_patient = Pathology.cast_patient(patient)
      seed_pathology_requests_for(patient: pathology_patient)
      seed_pathology_observations_for(patient: pathology_patient)
    end

    def random_date_between(date1, date2)
      Time.zone.at((date2.to_f - date1.to_f) * rand + date1.to_f)
    end
  end
end
