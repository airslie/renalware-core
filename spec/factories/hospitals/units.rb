FactoryBot.define do
  factory :hospital_unit, class: "Renalware::Hospitals::Unit" do
    hospital_centre
    name { "Dover Hospital" }
    unit_code { "UJZ" }
    renal_registry_code { "DOV" }
    unit_type { :hospital }

    factory :hd_hospital_unit do
      is_hd_site { true }
    end
  end
end
