# frozen_string_literal: true

module Renalware
  log "Adding Renal Consultants" do
    Renal::Consultant.find_or_create_by(code: "A", name: "Dr Jonathon Strange")
    Renal::Consultant.find_or_create_by(code: "B", name: "Melissa Montefiori")
  end
end
