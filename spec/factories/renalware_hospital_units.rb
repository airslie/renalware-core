FactoryGirl.define do
  factory :renalware_hospital_unit, :class => 'Renalware::HospitalUnit' do
    hospital nil
name "MyString"
unit_code "MyString"
renal_registry_code "MyString"
unit_type "MyString"
is_hd_site false
is_transplant_site false
  end

end
