table_model_map = {
  drugs: Renalware::Drugs::Drug,
  drug_types: Renalware::Drugs::Type,
  event_types: Renalware::Events::Type,
  ethnicities: Renalware::Ethnicity,
  modality_descriptions: Renalware::Modalities::Description,
  edta_codes: Renalware::EdtaCode,
  prd_descriptions: Renalware::PRDDescription,
  organism_codes: Renalware::OrganismCode,
  modality_reasons: Renalware::Modalities::Reason,
  medication_routes: Renalware::MedicationRoute,
  episode_types: Renalware::EpisodeType,
  fluid_descriptions: Renalware::FluidDescription,
  bag_types: Renalware::BagType,
  clinics: Renalware::Clinics::Clinic,
  transplant_registration_status_descriptions:
    Renalware::Transplants::RegistrationStatusDescription,
  transplant_failure_cause_description_groups: Renalware::Transplants::FailureCauseDescriptionGroup,
  transplant_failure_cause_descriptions: Renalware::Transplants::FailureCauseDescription,
  access_sites: Renalware::Accesses::Site,
  access_types: Renalware::Accesses::Type,
  access_plans: Renalware::Accesses::Plan,
  hospital_centres: Renalware::Hospitals::Centre,
  hospital_units: Renalware::Hospitals::Unit,
  hd_cannulation_types: Renalware::HD::CannulationType,
  hd_dialysers: Renalware::HD::Dialyser,
  letter_letterheads: Renalware::Letters::Letterhead,
  pathology_observation_descriptions: Renalware::Pathology::ObservationDescription,
  pathology_labs: Renalware::Pathology::Lab,
  pathology_request_descriptions: Renalware::Pathology::RequestDescription,
  users: Renalware::User,
  patient_religions: Renalware::Patients::Religion,
  patient_languages: Renalware::Patients::Language
}

Before do
  ActiveRecord::FixtureSet.reset_cache
  fixtures_folder = File.join(Rails.root, "features", "support", "fixtures")
  fixtures = Dir[File.join(fixtures_folder, "*.yml")].map {|f| File.basename(f, ".yml") }
  ActiveRecord::FixtureSet.create_fixtures(fixtures_folder, fixtures, table_model_map)
end
