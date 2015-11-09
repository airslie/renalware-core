FactoryGirl.define do
  factory :transplant_registration_status,
    class: Renalware::Transplants::RegistrationStatus do
    description { create(:transplant_registration_status_description) }
    started_on Time.zone.today
    association :created_by,  factory: :user
    association :updated_by,  factory: :user
  end
end
