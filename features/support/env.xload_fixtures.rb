# frozen_string_literal: true

require "database_cleaner"
require_relative "./env"

class Fixtures
  MODELS = [
    Renalware::Accesses::Site,
    Renalware::Accesses::Type,
    Renalware::Accesses::PlanType,
    Renalware::Accesses::CatheterInsertionTechnique,
    Renalware::Clinics::Clinic,
    Renalware::Deaths::Cause,
    Renalware::Drugs::Drug,
    Renalware::Drugs::Type,
    Renalware::Events::Category,
    Renalware::Events::Type,
    Renalware::HD::CannulationType,
    Renalware::HD::Dialyser,
    Renalware::HD::DiurnalPeriodCode,
    Renalware::HD::ScheduleDefinition,
    Renalware::Hospitals::Centre,
    Renalware::Hospitals::Unit,
    Renalware::Letters::Letterhead,
    Renalware::Letters::ContactDescription,
    Renalware::Modalities::Description,
    Renalware::Modalities::Reason,
    Renalware::Medications::MedicationRoute,
    Renalware::Patients::Religion,
    Renalware::Patients::Language,
    Renalware::Patients::Ethnicity,
    Renalware::Pathology::MeasurementUnit,
    Renalware::Pathology::ObservationDescription,
    Renalware::Pathology::Lab,
    Renalware::Pathology::RequestDescription,
    Renalware::PD::FluidDescription,
    Renalware::PD::BagType,
    Renalware::PD::System,
    Renalware::PD::OrganismCode,
    Renalware::PD::PeritonitisEpisodeTypeDescription,
    Renalware::Renal::PRDDescription,
    Renalware::Transplants::RegistrationStatusDescription,
    Renalware::Transplants::FailureCauseDescriptionGroup,
    Renalware::Transplants::FailureCauseDescription,
    Renalware::User
  ].freeze

  def reload
    elapsed_ms = Benchmark.ms do
      ActiveRecord::FixtureSet.reset_cache
      ActiveRecord::FixtureSet.create_fixtures(fixtures_folder, fixtures, table_model_map)
    end
    puts "  Reloading fixtures took #{elapsed_ms.round(2)}ms"
  end

  def table_model_map
    MODELS.index_by { |model| model.table_name.to_sym }
  end

  def fixtures_folder
    @fixtures_folder ||= Renalware::Engine.root.join("features", "support", "fixtures")
  end

  def fixtures
    @fixtures ||= begin
      Dir[File.join(fixtures_folder, "*.yml")].map { |f| File.basename(f, ".yml") }
    end
  end

  def web_depth?
    ENV["TEST_DEPTH"] == "web"
  end
end

fixtures = Fixtures.new

# If we are running domain level features we will be using DatabaseCleaner.strategy = :truncation
# (see features/support/database_cleaner.rb) so must reload fixtures before each scenario. If
# running domain features then we will be using DatabaseCleaner.strategy = :transaction so just
# load the fixtures up front (much faster of course).
if fixtures.web_depth?
  Before do
    fixtures.reload
  end
else
  fixtures.reload

  # A hack to handle legacy cucumber features that are not split into Domain and Web worlds.
  Before("@legacy") do
    DatabaseCleaner.strategy = :deletion
    fixtures.reload
    DatabaseCleaner.strategy = :transaction
  end
end
