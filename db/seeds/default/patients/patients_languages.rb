module Renalware
  log "Adding Languages" do

    file_path = File.join(File.dirname(__FILE__), "patients_languages.csv")

    CSV.foreach(file_path, headers: true) do |row|
      Patients::Language.find_or_create_by!(code: row["code"], name: row["name"])
    end
  end
end
