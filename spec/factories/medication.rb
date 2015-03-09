FactoryGirl.define do
  factory :medication do
    patient_id 1
    medication_id 1
    user_id "1"
    medication_type "Esa"
    dose "20mg"
    route "po"
    frequency "daily"
    notes "with food"
    date "2015"
    deleted_at "NULL"
    created_at "2015-02-03 18:21:04"
    updated_at "2015-02-05 18:21:04"
  end
end