# frozen_string_literal: true

# rubocop:disable Style/WordArray
module Renalware
  log "Adding Drug Types" do
    Drugs::Drug.transaction do
      [
        ["Antibiotic", "antibiotic"],
        ["ESA", "esa"],
        ["Immunosuppressant", "immunosuppressant"],
        ["Peritonitis", "peritonitis"],
        ["Controlled", "controlled"],
        ["Bone/Calcium/Phosphate", "bone/Ca/PO4"]
      ].each do |drug_type|
        Drugs::Type.find_or_create_by!(code: drug_type[1]) do |type|
          type.name = drug_type[0]
        end
      end
    end
  end
end
# rubocop:enable Style/WordArray
