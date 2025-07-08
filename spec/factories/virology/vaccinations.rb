FactoryBot.define do
  factory :vaccination, class: "Renalware::Virology::Vaccination" do
    event_type factory: :vaccination_event_type
    document { { type: "code", drug: "The drug" } }
  end
end
