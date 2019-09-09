# frozen_string_literal: true

FactoryBot.define do
  factory :transplant_donor_modality_description,
          class: "Renalware::Transplants::DonorModalityDescription" do
    name { "Live Donor" }
  end

  factory(
    :transplant_modality_description,
    class: "Renalware::Transplants::RecipientModalityDescription"
  ) do
    initialize_with do
      Renalware::Transplants::RecipientModalityDescription.find_or_create_by(name: "Transplant")
    end
  end
end
