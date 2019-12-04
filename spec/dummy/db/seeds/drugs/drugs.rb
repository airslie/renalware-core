# frozen_string_literal: true

module Renalware
  log "Adding Drugs" do
    file_path = File.join(File.dirname(__FILE__), "drugs.csv")

    if Drugs::Drug.count == 0
      drugs = CSV.read(file_path, headers: false)
      columns = drugs[0]
      Drugs::Drug.import! columns, drugs[1..-1], validate: true
    else
      # There are already drugs so use an idempotent approach
      CSV.foreach(file_path, headers: true) do |row|
        Drugs::Drug.find_or_create_by!(name: row["name"])
      end
    end
  end

  # log "Adding Blood Transfusion drug" do
  #   Drugs::Drug.find_or_create_by!(name: "Blood Transfusion")
  # end
end
