FactoryGirl.define do
  factory :body_composition, class: "Renalware::Clinical::BodyComposition"do
    patient

    assessed_on 1.week.ago
    overhydration "34.1"
    volume_of_distribution "52.1"
    total_body_water "23.1"
    extracellular_water "63.1"
    intracellular_water "23.1"
    lean_tissue_index "78.1"
    fat_tissue_index "32.1"
    lean_tissue_mass "32.1"
    fat_tissue_mass "42.1"
    adipose_tissue_mass "15.1"
    body_cell_mass "53.1"
    quality_of_reading "65.123"

    association :assessor, factory: :user
    association :created_by,  factory: :user
    association :updated_by,  factory: :user
  end
end
