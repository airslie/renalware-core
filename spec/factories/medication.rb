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
    date "25/02/2015"
    deleted_at "NULL"
    created_at "2015-02-03 18:21:04"
    updated_at "2015-02-05 18:21:04"
  end
end
