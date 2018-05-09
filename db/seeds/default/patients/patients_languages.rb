# frozen_string_literal: true

module Renalware
  log "Adding Languages" do
    return if Patients::Language.count > 0
    file_path = File.join(File.dirname(__FILE__), "patients_languages.csv")
    languages = []
    CSV.foreach(file_path, headers: true) do |row|
      languages << Patients::Language.new(code: row["code"], name: row["name"])
    end
    Patients::Language.import! languages
  end
end
