# frozen_string_literal: true

module Renalware
  log "Adding Clinics" do
    file_path = File.join(File.dirname(__FILE__), "clinics.csv")

    CSV.foreach(file_path, headers: true) do |row|
      Clinics::Clinic.find_or_create_by!(name: row["name"], code: row["code"]) do |clinic|
        clinic.consultant = SystemUser.find
      end
    end
  end
end
