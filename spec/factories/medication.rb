FactoryGirl.define do
  factory :medication do
    patient_id 1
    user_id "1"
    medicate_with_id 1
    medicate_with_type "Drug"
    dose "20mg"
    medication_route_id 1
    frequency "daily"
    notes "with food"
    date "2015"
    deleted_at "NULL"
    created_at "2015-02-03 18:21:04"
    updated_at "2015-02-05 18:21:04"
  end
end