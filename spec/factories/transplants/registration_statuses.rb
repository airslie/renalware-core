FactoryGirl.define do
  factory :transplant_registration_status,
    class: Renalware::Transplants::RegistrationStatus do
    started_on Time.zone.today
  end
end
