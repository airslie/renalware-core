FactoryGirl.define do
  factory :clinic_visit, class: "Renalware::ClinicVisit" do
    patient
    date Time.now
    height 1725
    weight 6985
    systolic_bp 112
    diastolic_bp 71
    clinic_type
    association :created_by, factory: :user
    association :updated_by, factory: :user
  end
end
