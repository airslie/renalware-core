require_dependency "renalware"

Renalware::Patients.configure
Renalware::Pathology.configure
Renalware::PD.configure do |config|
  # ...
end
