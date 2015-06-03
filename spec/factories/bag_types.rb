FactoryGirl.define do
  factory :bag_type do
    manufacturer "Star Brand, Lucky Brand"
    description "Green–2.34"
    glucose_ml_percent_1_36 10
    glucose_ml_percent_2_27 20
    glucose_ml_percent_3_86 30
    amino_acid_ml 40
    icodextrin_acid_ml 50
    low_glucose_degradation 1
    uses_low_sodium 0
  end
end
