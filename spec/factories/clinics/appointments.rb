FactoryGirl.define do
  factory :appointment, class: "Renalware::Clinics::Appointment" do
    patient
    clinic
    starts_at Time.zone.now
    association :user
  end
end
