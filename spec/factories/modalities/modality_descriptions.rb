FactoryGirl.define do
  factory :modality_description, class: "Renalware::Modalities::Description" do
    name "unspecific modality description not set in factory"

    initialize_with { Renalware::Modalities::Description.find_or_create_by(name: name) }

    trait :pd do
      name "PD"
      type "Renalware::PD::ModalityDescription"
    end

    trait :hd do
      name "HD"
      type "Renalware::HD::ModalityDescription"
    end

    trait :transplant do
      name "Transplant"
      type "Renalware::Transplants::RecipientModalityDescription"
    end

    trait :lcc do
      name "LCC"
    end

    trait :death do
      name "Death"
      type "Renalware::Deaths::ModalityDescription"
    end

    trait :live_donor do
      name "Live Donor"
      type "Renalware::Transplants::DonorModalityDescription"
    end
  end
end
