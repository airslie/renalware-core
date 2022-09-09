# frozen_string_literal: true

module Renalware
  log "Adding demo clinic with an associated clinic visit class with custom fields" do
    Clinics::Clinic.find_or_create_by!(name: "MyClinic", code: "myclinic") do |cli|
      cli.default_modality_description = Modalities::Description.find_by(code: "nephrology")
      cli.visit_class_name = "Clinics::MyVisit"
    end
  end
end
