# frozen_string_literal: true

module Renalware::Heroic
  log "Adding Heroic BioBank Sample Types" do
    {
      "Serum": "SER",
      "DNA": "WB-DNA",
      "RNA": "WB-RNA",
      "Urine-PL": "Urine-PL",
      "Urine-IN": "Urine-IN",
      "E-PLA": "E-PLA",
      "Tiss-Bx": "Tiss-Bx",
      "Renal biopsy": "Renal biopsy?"
    }.each do |name, abbreviation|
      BioBank::SampleType.find_or_create_by!(
        name: name,
        abbreviation: abbreviation
      )
    end
  end
end
