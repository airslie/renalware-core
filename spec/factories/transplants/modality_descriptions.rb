# frozen_string_literal: true

FactoryBot.define do
  factory :transplant_donor_modality_description,
          class: "Renalware::Transplants::DonorModalityDescription" do
    name { "Live Donor" }
  end

  factory :transplant_modality_description, class: "Renalware::HD::ModalityDescription" do
    initialize_with { Renalware::HD::ModalityDescription.find_or_create_by(name: "Transplant") }
  end
end
