FactoryGirl.define do
  factory :patient_alert, class: "Renalware::Patients::Alert" do
    notes Faker::Lorem.sentence
    urgent true
    association :created_by, factory: :user
    association :updated_by, factory: :user
  end
end
