FactoryGirl.define do
  factory :pathology_requests_request,
    class: "Renalware::Pathology::Requests::Request" do
      association :patient, factory: :pathology_patient
      association :clinic, factory: :clinic
      association :consultant, factory: :pathology_consultant
      telephone Faker::PhoneNumber.phone_number

      association :created_by,  factory: :user
      association :updated_by,  factory: :user
  end
end
