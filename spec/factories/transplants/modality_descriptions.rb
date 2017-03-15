FactoryGirl.define do
  factory :transplant_donor_modality_description,
          class: "Renalware::Transplants::DonorModalityDescription" do
    name "Live Donor"
  end

  factory :transplant_modality_description, class: "Renalware::HD::ModalityDescription" do
    name "Transplant"
  end
end
