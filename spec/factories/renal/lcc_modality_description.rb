FactoryBot.define do
  factory :low_clearance_modality_description, class: "Renalware::Deaths::ModalityDescription" do
    initialize_with do
      Renalware::Renal::LowClearance::ModalityDescription.find_or_create_by(
        name: "Low Clearance"
      )
    end
  end
end
