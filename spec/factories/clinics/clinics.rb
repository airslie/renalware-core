FactoryGirl.define do
  factory :clinic, class: "Renalware::Clinics::Clinic" do
    name "Access"
    association :consultant, factory: :user
  end
end
