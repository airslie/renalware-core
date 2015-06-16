FactoryGirl.define do
  factory :medication do |medication|
    patient
    association :medicatable, factory: :drug
    treatable_id nil
    treatable_type nil
    dose "20mg"
    medication_route
    frequency "daily"
    notes "with food"
    start_date "25/02/#{Date.current.year}"
    deleted_at "NULL"
  end
end
