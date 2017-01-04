FactoryGirl.define do
  factory :bag_type, class: "Renalware::PD::BagType" do
    manufacturer "Star Brand, Lucky Brand"
    description "Green–2.34"
    glucose_content 2.86
    amino_acid true
    icodextrin false
    low_glucose_degradation true
    low_sodium false
    sodium_content 20
    lactate_content 25
    bicarbonate_content 47
    calcium_content 1.56
    magnesium_content 2.67
  end
end
