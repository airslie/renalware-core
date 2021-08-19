# frozen_string_literal: true

module Renalware
  log "Adding comorbidity descriptions" do
    return if Problems::Comorbidities::Description.count > 0

    file_path = File.join(File.dirname(__FILE__), "comorbidity_descriptions.csv")
    descriptions = []
    CSV.foreach(file_path, headers: true) do |row|
      descriptions << Problems::Comorbidities::Description.new(
        name: row["name"],
        position: row["position"],
        snomed_code: row["snomed_code"]
      )
    end
    Problems::Comorbidities::Description.import! descriptions
  end
end
