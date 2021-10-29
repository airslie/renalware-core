# frozen_string_literal: true

module Renalware
  log "Adding Clinic Consultants" do
    Clinics::Consultant.find_or_create_by(code: "A", name: "Dr Jonathon Strange")
    Clinics::Consultant.find_or_create_by(code: "B", name: "Melissa Montefiori")
  end
end
