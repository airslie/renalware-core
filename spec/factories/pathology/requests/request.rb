FactoryGirl.define do
  factory :pathology_requests_request,
    class: "Renalware::Pathology::Requests::Request" do
      telephone Faker::PhoneNumber.phone_number

      association :created_by,  factory: :user
      association :updated_by,  factory: :user
  end
end
