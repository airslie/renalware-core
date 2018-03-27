# frozen_string_literal: true

require_dependency "renalware"

# New subscription registry - previous implementation does not work across threads

Renalware.configure do |config|
  config.broadcast_subscription_map = {
    "Renalware::Modalities::ChangePatientModality" => [
      "Renalware::Medications::PatientListener",
      "Renalware::Letters::PatientListener",
      "Renalware::HD::PatientListener"
    ],
    "Renalware::Letters::ApproveLetter" => [],
    "Renalware::Pathology::CreateObservationRequests" => []
  }
end

Renalware::Patients.configure
Renalware::Pathology.configure
Renalware::PD.configure do |config|
  # ...
end
