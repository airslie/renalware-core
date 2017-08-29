FactoryGirl.define do
  factory :hospital_unit, class: "Renalware::Hospitals::Unit" do
    hospital_centre
    name "King's College Hospital"
    unit_code "UJZ"
    renal_registry_code "RJZ"
    unit_type :hospital
    number_of_hd_stations nil

    factory :hd_hospital_unit do
      is_hd_site true
      number_of_hd_stations 10
    end
  end
end
