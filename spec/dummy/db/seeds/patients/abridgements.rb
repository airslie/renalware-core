# frozen_string_literal: true

module Renalware
  extend SeedsHelper

  log "Adding Abridged Patients" do
    abridgements = []
    file_path = Rails.root.join(File.dirname(__FILE__), "abridgements.csv")
    CSV.foreach(file_path, headers: true) do |row|
      abridgements << Patients::Abridgement.find_or_initialize_by(
        hospital_number: row["hospital_number"],
        family_name: row["family_name"],
        given_name: row["given_name"],
        born_on: row["born_on"],
        sex: row["sex"]
      )
    end
    Patients::Abridgement.import! abridgements
  end
end
