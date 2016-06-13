FactoryGirl.define do
  factory :clinic, class: "Renalware::Clinics::Clinic" do
    name "Access"
    association :user, factory: :user
  end
end
