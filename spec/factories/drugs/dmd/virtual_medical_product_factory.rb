FactoryBot.define do
  factory :dmd_virtual_medical_product, class: "Renalware::Drugs::DMD::VirtualMedicalProduct" do
    sequence(:code) { "Code#{it}" }
  end
end
