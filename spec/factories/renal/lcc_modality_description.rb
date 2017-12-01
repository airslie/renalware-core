FactoryBot.define do
  factory :lcc_modality_description, class: "Renalware::Deaths::ModalityDescription" do
    initialize_with do
      Renalware::Renal::LowClearance::ModalityDescription.find_or_create_by(name: "LCC")
    end
  end
end
