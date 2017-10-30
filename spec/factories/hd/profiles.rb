FactoryBot.define do
  factory :hd_profile, class: "Renalware::HD::Profile" do
    accountable
    patient
    active true
    association :hospital_unit, factory: :hospital_unit
    association :dialysate, factory: :hd_dialysate
    prescriber { accountable_actor }

    document {
      {
        dialysis: {
          hd_type: :hd
        }
      }
    }
  end
end
