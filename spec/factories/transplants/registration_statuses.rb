FactoryGirl.define do
  factory :transplant_registration_status,
    class: Renalware::Transplants::RegistrationStatus do
    description { create(:transplant_registration_status_description) }
    started_on Time.zone.today
    created_by_id 0
    updated_by_id 0
  end
end
