# frozen_string_literal: true

module Renalware
  log "Adding Patients" do
    # without_papertrail_versioning_for(Patient) do
    file_path = Rails.root.join(File.dirname(__FILE__), "patients.csv")
    system_user = SystemUser.find
    countries = System::Country.all
    patients = []
    default_hospital_centre = Hospitals::Centre.find_by!(code: "QC001")

    Patient.transaction do
      CSV.foreach(file_path, headers: true) do |row|
        local_patient_id = row["local_patient_id"]
        break if local_patient_id.blank?

        pat = Patient.find_or_initialize_by(local_patient_id: local_patient_id) do |patient|
          patient.family_name = row["family_name"]
          patient.given_name = row["given_name"]
          patient.sex = row["sex"]
          patient.born_on = row["born_on"]
          patient.nhs_number = row["nhs_number"]
          patient.created_at = row["created_at"]
          patient.send_to_rpv = row["send_to_rpv"]
          patient.created_by_id = system_user.id
          patient.updated_by_id = system_user.id
          # These 2 uuids are normally set in before_save callbacks
          # which are not available to us if using .import! (see below)
          patient.ukrdc_external_id = SecureRandom.uuid
          patient.secure_id = SecureRandom.uuid
          patient.hospital_centre = default_hospital_centre
        end

        address = pat.current_address || pat.build_current_address
        address.street_1 = Faker::Address.secondary_address
        address.street_2 = Faker::Address.street_address
        address.town = Faker::Address.city
        address.county = Faker::Address.state
        address.postcode = Faker::Address.postcode
        address.country = countries.sample
        patients << pat
      end

      Patient.import! patients, validate: false
    end
  end
end
