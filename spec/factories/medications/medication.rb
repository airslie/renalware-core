FactoryGirl.define do
  factory :medication, class: "Renalware::Medication" do |medication|
    patient
    drug
    dose "20mg"
    medication_route
    frequency "daily"
    notes "with food"
    provider 0
    start_date 2.weeks.ago

    before(:create) { |medication| medication.treatable ||= medication.patient }

    trait :terminated do
      deleted_at 1.week.ago
    end
  end
end
