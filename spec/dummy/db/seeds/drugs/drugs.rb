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

  log "Adding Vaccination drugs" do
    vaccination_drug_type = Drugs::Type.find_by!(code: "vaccine")
    [
      "HBVAXPRO 40 micrograms (hepatitis B vaccine)"
    ].each do |name|
      drug = Drugs::Drug.find_or_create_by!(name: name)
      drug.drug_types << vaccination_drug_type
      drug.save!
    end
  end
end
