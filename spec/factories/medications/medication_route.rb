FactoryGirl.define do
  factory :medication_route, class: "Renalware::MedicationRoute" do
    code "PO"
    name "Per Oral"
  end

  trait :other do
    code "Other"
    name "Other"
  end
end
