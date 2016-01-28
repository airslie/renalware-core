FactoryGirl.define do
  factory :medication, class: "Renalware::Medication" do |medication|
    patient
    drug
    treatable_id nil
    treatable_type nil
    dose "20mg"
    medication_route
    frequency "daily"
    notes "with food"
    provider 0
    start_date "25/02/#{Date.current.year}"
    deleted_at "NULL"

    before(:create) { |medication| medication.treatable ||= medication.patient }
  end
end
