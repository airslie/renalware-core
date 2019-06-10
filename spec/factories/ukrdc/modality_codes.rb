# frozen_string_literal: true

FactoryBot.define do
  factory :ukrdc_modality_code, class: Renalware::UKRDC::ModalityCode do
    trait :hd do
      description { "Haemodialysis" }
      txt_code { 1 }
      qbl_code { 1 }
    end

    trait :hdf do
      description { "Haemodiafiltration" }
      txt_code { 3 }
      qbl_code { 3 }
    end
  end
end
