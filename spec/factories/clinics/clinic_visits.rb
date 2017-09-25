FactoryGirl.define do
  factory :clinic_visit, class: "Renalware::Clinics::ClinicVisit" do
    accountable
    patient
    date Time.zone.today
    time Time.zone.now
    did_not_attend false
    height 1725
    weight 6985
    pulse 100
    systolic_bp 112
    diastolic_bp 71
    clinic { create(:clinic, consultant: accountable_actor) }
  end
end
