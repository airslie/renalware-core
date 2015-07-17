FactoryGirl.define do
  factory :clinic do
    patient
    date Time.now
    height 1725
    weight 6985
    systolic_bp 112
    diastolic_bp 71
  end
end
