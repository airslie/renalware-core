FactoryGirl.define do
  factory :medication do
    patient
    user_id 1
    medicatable_id 1
    medicatable_type "Drug"
    treatable_id nil
    treatable_type nil
    dose "20mg"
    medication_route_id 1
    frequency "daily"
    notes "with food"
    date "25/02/2015"
    deleted_at "NULL"
    created_at "2015-02-03 18:21:04"
    updated_at "2015-02-05 18:21:04"
  end
end