FactoryBot.define do
  factory :dmd_virtual_therapeutic_moiety,
          class: "Renalware::Drugs::DMD::VirtualTherapeuticMoiety" do
    sequence(:code) { "Code#{it}" }
  end
end
