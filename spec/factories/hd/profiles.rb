# frozen_string_literal: true

FactoryBot.define do
  factory :hd_profile, class: "Renalware::HD::Profile" do
    accountable
    patient
    active { true }
    association :hospital_unit, factory: :hospital_unit
    association :dialysate, factory: :hd_dialysate
    scheduled_time { "11:00" }
    prescriber { accountable_actor }

    document {
      {
        dialysis: {
          hd_type: :hd
        }
      }
    }

    trait :hd do
      # noop
    end

    trait :hdf_pre do
      document {
        {
          dialysis: {
            hd_type: :hdf_pre
          }
        }
      }
    end

    trait :hdf_post do
      document {
        {
          dialysis: {
            hd_type: :hdf_post
          }
        }
      }
    end
  end
end
