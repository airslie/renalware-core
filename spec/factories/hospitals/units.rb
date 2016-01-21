FactoryGirl.define do
  factory :hospital_unit, class: "Renalware::Hospitals::Unit" do
    hospital_centre
    name "King's College Hospital"
    unit_code "UJZ"
    renal_registry_code "RJZ"
    unit_type :hospital
  end
end
