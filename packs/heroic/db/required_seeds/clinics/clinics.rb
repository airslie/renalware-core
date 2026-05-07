# frozen_string_literal: true

module Renalware::Heroic
  log "Adding Heroic Clinic" do
    Renalware::Clinics::Clinic.find_or_create_by!(name: "HEROIC") do |clinic|
      clinic.visit_class_name = "Renalware::Heroic::Clinics::Visit"
    end
  end
end
