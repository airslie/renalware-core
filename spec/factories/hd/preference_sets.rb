FactoryGirl.define do
  factory :hd_preference_set, class: "Renalware::HD::PreferenceSet" do
    patient
    association :hospital_unit, factory: :hospital_unit
    schedule :mon_wed_fri_pm
    other_schedule ""
    association :created_by,  factory: :user
    association :updated_by,  factory: :user
  end
end
