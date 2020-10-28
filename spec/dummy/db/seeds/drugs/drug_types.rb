# frozen_string_literal: true

# rubocop:disable Style/WordArray
module Renalware
  log "Adding Drug Types" do
    Drugs::Drug.transaction do
      [
        ["Antibiotic", "antibiotic"],
        ["ESA", "esa", "#ff9", 200],
        ["Immunosuppressant", "immunosuppressant", "#ccfeff", 100],
        ["Peritonitis", "peritonitis"],
        ["Controlled", "controlled"],
        ["Bone/Calcium/Phosphate", "bone/Ca/PO4"],
        ["Vaccine", "vaccine"]
      ].each_with_index do |drug_type, idx|
        Drugs::Type.find_or_create_by!(code: drug_type[1]) do |type|
          type.name = drug_type[0]
          type.position = idx
          type.colour = drug_type[2] # optional, nil == type has no color
          type.weighting = drug_type[3] || 0 # optional, see comments in migration for function
        end
      end
    end
  end
end
# rubocop:enable Style/WordArray
