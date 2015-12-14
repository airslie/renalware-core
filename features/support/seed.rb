AfterConfiguration do |scenario|
  if Renalware::Transplants::RegistrationStatusDescription.count == 0
    DatabaseCleaner.clean
    load Rails.root.join("db/seeds.rb")
    DatabaseCleaner.clean
  end
end
