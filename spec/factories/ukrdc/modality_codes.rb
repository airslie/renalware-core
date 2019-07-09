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

    trait :pd do
      description { "Peritoneal dialysis – type unknown" }
      txt_code { 19 }
      qbl_code { 19 }
    end

    trait :apd do
      description { "APD" }
      txt_code { 12 }
      qbl_code { 12 }
    end

    trait :capd do
      description { "CAPD" }
      txt_code { 11 }
      qbl_code { 11 }
    end

    # 111,111,Assisted CAPD
    # 121,121,Assisted APD
  end
end
