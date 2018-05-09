# frozen_string_literal: true

module Renalware
  log "Adding Countries" do
    return if System::Country.count > 0
    file_path = File.join(File.dirname(__FILE__), "countries.csv")
    countries = []
    CSV.foreach(file_path, headers: true) do |row, index|
      countries << System::Country.new(
        name: row["name"],
        alpha2: row["alpha2"],
        alpha3: row["alpha3"],
        position: index
      )
    end
    System::Country.import! countries
  end
end
