# frozen_string_literal: true

module Renalware
  log "Creating Admission::ConsultSites" do
    ["Site A", "Site B", "Site C"].each do |name|
      Admissions::ConsultSite.find_or_create_by!(name: name)
    end
  end
end
