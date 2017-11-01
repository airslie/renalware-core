FactoryBot.define do
  factory :admissions_consult, class: "Renalware::Admissions::Consult" do
    accountable
    patient { create(:patient, by: accountable_actor) }
    hospital_unit
  end
end
