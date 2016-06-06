models = [
  Renalware::Drugs::Drug,
  Renalware::Drugs::Type,
  Renalware::Events::Type,
  Renalware::Ethnicity,
  Renalware::Modalities::Description,
  Renalware::EdtaCode,
  Renalware::PRDDescription,
  Renalware::OrganismCode,
  Renalware::Modalities::Reason,
  Renalware::MedicationRoute,
  Renalware::EpisodeType,
  Renalware::FluidDescription,
  Renalware::BagType,
  Renalware::Clinics::Clinic,
  Renalware::Transplants::RegistrationStatusDescription,
  Renalware::Transplants::FailureCauseDescriptionGroup,
  Renalware::Transplants::FailureCauseDescription,
  Renalware::Accesses::Site,
  Renalware::Accesses::Type,
  Renalware::Accesses::Plan,
  Renalware::Hospitals::Centre,
  Renalware::Hospitals::Unit,
  Renalware::HD::CannulationType,
  Renalware::HD::Dialyser,
  Renalware::Letters::Letterhead,
  Renalware::Pathology::ObservationDescription,
  Renalware::Pathology::Lab,
  Renalware::Pathology::RequestDescription,
  Renalware::User,
  Renalware::Patients::Religion,
  Renalware::Patients::Language
]

table_model_map = models.each_with_object({}) { |model, hsh| hsh[model.table_name.to_sym] = model }

Before do
  ActiveRecord::FixtureSet.reset_cache
  fixtures_folder = File.join(Rails.root, "features", "support", "fixtures")
  fixtures = Dir[File.join(fixtures_folder, "*.yml")].map {|f| File.basename(f, ".yml") }
  ActiveRecord::FixtureSet.create_fixtures(fixtures_folder, fixtures, table_model_map)
end
