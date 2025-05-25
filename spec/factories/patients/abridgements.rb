FactoryBot.define do
  factory :abridged_patient, class: "Renalware::Patients::Abridgement" do
    hospital_number { "99999" }
    given_name { "Aaron" }
    family_name { "BALLARD" }
  end
end
