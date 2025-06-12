FactoryBot.define do
  factory :modality, class: "Renalware::Modalities::Modality" do
    accountable
    patient
    change_type factory: :modality_change_type
    description factory: :modality_description
    started_on { Date.parse("2015-04-01") }
    trait :terminated do
      state { "terminated" }
    end
  end
end
