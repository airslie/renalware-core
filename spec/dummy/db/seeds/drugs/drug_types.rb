# frozen_string_literal: true

module Renalware
  log "Adding Drug Types" do
    Drugs::Drug.transaction do
      %w(
        Antibiotic
        ESA
        Immunosuppressant
        Peritonitis
        Controlled
      ).each do |drug_type|
        Drugs::Type.find_or_create_by!(code: drug_type.downcase) do |type|
          type.name = drug_type
        end
      end
    end
  end
end
