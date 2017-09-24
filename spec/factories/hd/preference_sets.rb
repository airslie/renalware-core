FactoryGirl.define do
  factory :hd_preference_set, class: "Renalware::HD::PreferenceSet" do
    accountable
    patient
    association :hospital_unit, factory: :hospital_unit
    schedule :mon_wed_fri_pm
    other_schedule ""
  end
end
