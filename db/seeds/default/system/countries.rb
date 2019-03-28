# frozen_string_literal: true

module Renalware
  log "Adding Countries" do
    return if System::Country.count.positive?

    file_path = File.join(File.dirname(__FILE__), "countries.csv")
    countries = []
    index = 0
    CSV.foreach(file_path, headers: true) do |row|
      countries << System::Country.new(
        name: row["name"],
        alpha2: row["alpha2"],
        alpha3: row["alpha3"],
        position: index
      )
      index += 1
    end
    System::Country.import! countries
  end
end
