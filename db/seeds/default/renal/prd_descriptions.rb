# frozen_string_literal: true

module Renalware
  log "Adding Primary Renal Diagnosis (PRD) Codes" do
    return if Renal::PRDDescription.count > 0
    file_path = File.join(File.dirname(__FILE__), "prd_descriptions.csv")
    descriptions = []
    CSV.foreach(file_path, headers: true) do |row|
      descriptions << Renal::PRDDescription.new(
        code: row["code"],
        term: row["term"]
      )
    end
    Renal::PRDDescription.import! descriptions
  end
end
