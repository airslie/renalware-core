begin
  namespace :audit do
    desc "Queues a delayed job to generate and store monthly patient HD Session statistics"
    task patient_hd_statistics: :environment do
      Renalware::HD::GenerateMonthlyStatisticsJob.perform_later
    end
  end
end
