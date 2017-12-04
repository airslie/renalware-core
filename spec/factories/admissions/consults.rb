FactoryBot.define do
  factory :admissions_consult, class: "Renalware::Admissions::Consult" do
    accountable
    patient { create(:patient, by: accountable_actor) }
    association :consult_site, factory: :admissions_consult_site
  end
end
