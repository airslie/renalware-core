FactoryGirl.define do
  factory :bag_type, class: "Renalware::BagType" do
    manufacturer "Star Brand, Lucky Brand"
    description "Green–2.34"
    glucose_grams_per_litre 28.6
    amino_acid true
    icodextrin false
    low_glucose_degradation true
    low_sodium false
    sodium_mmole_l 20
    lactate_mmole_l 25
    bicarbonate_mmole_l 47
    calcium_mmole_l 1.56
    magnesium_mmole_l 2.67
  end
end
