FactoryBot.define do
  factory :admissions_inpatient, class: "Renalware::Admissions::Inpatient" do
    accountable
    patient { create(:patient, by: accountable_actor) }
    admitted_on { Time.zone.today }
    admission_type :unknown
    reason_for_admission "Reason"
    hospital_unit
    hospital_ward
  end
end
