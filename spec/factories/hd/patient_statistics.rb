FactoryGirl.define do
  factory :hd_patient_statistics, class: "Renalware::HD::PatientStatistics" do
    patient factory: :hd_patient
    association :hospital_unit, factory: :hospital_unit
    month 0 # rolling
    year 0  # rolling
  end
end
