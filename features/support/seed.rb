AfterConfiguration do |scenario|
  if Renalware::Transplants::RegistrationStatusDescription.count == 0
    load Rails.root.join('db/seeds.rb')
    DatabaseCleaner.clean
  end
end