namespace :ods do
  desc "Sync practices and GPs from NHS ODS Data Search and Export"
  task sync: :environment do
    Renalware::Patients::SyncODSJob.perform_later(dry_run: ENV["dry_run"] == "true")
  end
end
